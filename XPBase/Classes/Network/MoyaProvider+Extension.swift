//
//  MoyaProvider+Extension.swift
//  SZParking
//
//  Created by nbfujx on 2020/8/10.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import Foundation
import HandyJSON
import Moya
import Toast_Swift

/// 网络请求全局配置结构体
/// 用于统一配置网络请求的行为和提示文案
///
/// 使用示例：
/// ```swift
/// // 在 AppDelegate 或 SceneDelegate 中配置
/// MoyaConfig.successCode = "200"
/// MoyaConfig.unauthorizedCode = "401"
/// MoyaConfig.serverDataErrorText = "数据解析失败"
/// MoyaConfig.networkErrorText = "网络连接失败"
/// MoyaConfig.networkStatusErrorText = "请检查网络连接"
/// 
/// // 设置全局加载状态回调
/// MoyaConfig.loadingHandler = { isLoading in
///     if isLoading {
///         SVProgressHUD.show()
///     } else {
///         SVProgressHUD.dismiss()
///     }
/// }
/// 
/// // 设置自定义网络状态检查
/// MoyaConfig.networkStatusChecker = {
///     return ReachabilityManager.shared.isReachable
/// }
/// ```
public struct MoyaProviderConfig {
    /// 成功响应的状态码（默认 "1"）
    public var successCode: String = "1"
    /// 未授权状态码，触发登录页面跳转（默认 "401"）
    public var unauthorizedCode: String = "401"
    /// XPCodeMsgModel 类名标识，用于特殊处理只返回状态码和消息的响应
    public var codeMsgModelIdentifier: String = "XPCodeMsgModel"
    /// 登录页面通知名称，当收到未授权响应时发送此通知
    public var loginNotificationName: String = "NotificationShowLoginName"
    /// 服务器数据错误提示文案
    public var serverDataErrorText: String = "服务器数据错误"
    /// 网络请求失败提示文案
    public var networkErrorText: String = "网络请求失败"
    /// 网络状态错误提示文案
    public var networkStatusErrorText: String = "请检查您的网络"
    /// 加载状态回调，用于显示/隐藏加载指示器
    public var loadingHandler: ((Bool) -> Void)?
    /// 自定义网络状态检查闭包，优先级高于默认检查
    public var networkStatusChecker: (() -> Bool)?
}

/// 网络请求全局配置实例
/// 在应用启动时配置，全局生效
public var MoyaConfig = MoyaProviderConfig()

public extension MoyaProvider {
    /// 发送网络请求并自动解析响应数据
    /// 封装了网络状态检查、加载状态管理、响应解析和错误处理
    ///
    /// 使用示例：
    /// ```swift
    /// // 定义 API
    /// enum MyAPI {
    ///     case getUserInfo(userId: Int)
    ///     case updateUserInfo(name: String)
    /// }
    /// 
    /// // 定义数据模型
    /// struct UserInfo: HandyJSON {
    ///     var id: Int?
    ///     var name: String?
    ///     var avatar: String?
    /// }
    /// 
    /// // 创建请求提供者
    /// let provider = MoyaProvider<MyAPI>(plugins: [XPNetworkLoggerPlugin()])
    /// 
    /// // 发起请求（基本用法）
    /// provider.request(.getUserInfo(userId: 1), model: UserInfo.self) { userInfo in
    ///     if let user = userInfo {
    ///         print("用户名称: \(user.name ?? "")")
    ///     }
    /// }
    /// 
    /// // 发起请求（显示加载指示器）
    /// provider.request(.updateUserInfo(name: "张三"), 
    ///                  model: UserInfo.self, 
    ///                  showLoading: true) { userInfo in
    ///     // 处理响应
    /// }
    /// 
    /// // 发起请求（不显示错误提示）
    /// provider.request(.getUserInfo(userId: 1), 
    ///                  model: UserInfo.self, 
    ///                  showMsg: false) { userInfo in
    ///     // 处理响应
    /// }
    /// 
    /// // 发起请求（自定义成功状态码）
    /// provider.request(.getUserInfo(userId: 1), 
    ///                  model: UserInfo.self, 
    ///                  responseSuccessCode: "200") { userInfo in
    ///     // 处理响应
    /// }
    /// 
    /// // 取消请求
    /// let cancellable = provider.request(.getUserInfo(userId: 1), model: UserInfo.self) { _ in }
    /// cancellable?.cancel()
    /// ```
    ///
    /// - Parameters:
    ///   - target: API 目标（遵循 TargetType 协议）
    ///   - model: 响应数据模型类型（需遵循 HandyJSON 协议）
    ///   - showLoading: 是否显示加载指示器（默认 false）
    ///   - showMsg: 是否自动显示错误信息（默认 true）
    ///   - responseSuccessCode: 成功响应的状态码（默认使用 MoyaConfig.successCode）
    ///   - completion: 响应完成回调，返回解析后的模型对象
    /// - Returns: 可取消的请求对象，可用于取消正在进行的请求
    @discardableResult
    func request<T>(_ target: Target,
                    model: T.Type,
                    showLoading: Bool = false,
                    showMsg: Bool = true,
                    responseSuccessCode: String = MoyaConfig.successCode,
                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        // 网络状态检查
        let isNetworkAvailable: Bool
        if let networkStatusChecker = MoyaConfig.networkStatusChecker {
            isNetworkAvailable = networkStatusChecker()
        } else {
            isNetworkAvailable = networkStatusJudgment()
        }
        
        guard isNetworkAvailable else {
            showToastText(text: MoyaConfig.networkStatusErrorText)
            completion?(nil)
            return nil
        }

        // 显示加载指示器
        if showLoading {
            MoyaConfig.loadingHandler?(true)
        }

        // 发送网络请求
        return request(target) { [weak self] result in
            // 隐藏加载指示器
            if showLoading {
                MoyaConfig.loadingHandler?(false)
            }

            // 处理响应结果
            switch result {
            case let .success(response):
                self?.handleSuccessResponse(response, model: model, responseSuccessCode: responseSuccessCode, showMsg: showMsg, completion: completion)
            case let .failure(error):
                self?.handleErrorResponse(error, completion: completion)
            }
        }
    }

    /// 处理成功响应
    /// - Parameters:
    ///   - response: 网络响应
    ///   - model: 响应数据模型类型
    ///   - responseSuccessCode: 成功响应的状态码
    ///   - showMsg: 是否显示错误信息
    ///   - completion: 响应完成回调
    private func handleSuccessResponse<T>(_ response: Response, model: T.Type, responseSuccessCode: String, showMsg: Bool, completion: ((_ returnData: T?) -> Void)?) {
        // 解析 JSON 数据
        guard let jsonDic = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments) as? [String: Any] else {
            showToastText(text: MoyaConfig.serverDataErrorText)
            completion?(nil)
            return
        }

        // 解析响应模型（NetworkLoggerPlugin 已处理日志输出）
        guard let jsonData = JSONDeserializer<XPBaseModel<T>>.deserializeFrom(dict: jsonDic) else {
            showToastText(text: MoyaConfig.serverDataErrorText)
            completion?(nil)
            return
        }

        // 处理响应状态码
        if jsonData.code == responseSuccessCode {
            // 处理 XPCodeMsgModel 特殊情况
            let clsString = String(describing: type(of: jsonData))
            if clsString.contains(MoyaConfig.codeMsgModelIdentifier) && jsonData.data == nil {
                let m = XPCodeMsgModel()
                m.code = Int(jsonData.code ?? "0") ?? -1
                m.msg = jsonData.msg
                jsonData.data = (m as! T)
            }
            completion?(jsonData.data)
        } else if jsonData.code == MoyaConfig.unauthorizedCode {
            // 发送登录页面通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: MoyaConfig.loginNotificationName), object: nil)
            completion?(nil)
        } else {
            // 显示错误信息
            if showMsg, let msg = jsonData.msg, !msg.isEmpty {
                showToastText(text: msg)
            }
            completion?(nil)
        }
    }

    /// 处理错误响应
    /// - Parameters:
    ///   - error: 网络错误
    ///   - completion: 响应完成回调
    private func handleErrorResponse<T>(_ error: MoyaError, completion: ((_ returnData: T?) -> Void)?) {
        // 显示网络错误提示（NetworkLoggerPlugin 已处理日志输出）
        showToastText(text: MoyaConfig.networkErrorText)
        completion?(nil)
    }
}
