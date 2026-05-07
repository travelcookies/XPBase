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

// 网络请求配置结构体
public struct MoyaProviderConfig {
    /// 成功响应的状态码
    public var successCode: String = "1"
    /// 未授权状态码
    public var unauthorizedCode: String = "401"
    /// CodeMsgModel 类名标识
    public var codeMsgModelIdentifier: String = "CodeMsgModel"
    /// 登录页面通知名称
    public var loginNotificationName: String = "NotificationShowLoginName"
    /// 服务器数据错误提示
    public var serverDataErrorText: String = "服务器数据错误"
    /// 网络请求失败提示
    public var networkErrorText: String = "网络请求失败"
    /// 网络状态错误提示
    public var networkStatusErrorText: String = "请检查您的网络"
    /// 加载状态回调
    public var loadingHandler: ((Bool) -> Void)?
    /// 网络状态检查闭包
    public var networkStatusChecker: (() -> Bool)?
}

// 网络请求配置
public var MoyaConfig = MoyaProviderConfig()

public extension MoyaProvider {
    /// 发送网络请求并解析响应数据
    /// - Parameters:
    ///   - target: API 目标
    ///   - model: 响应数据模型类型
    ///   - showLoading: 是否显示加载指示器
    ///   - showMsg: 是否显示错误信息
    ///   - responseSuccessCode: 成功响应的状态码
    ///   - completion: 响应完成回调
    /// - Returns: 可取消的请求对象
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
        guard let jsonData = JSONDeserializer<BaseModel<T>>.deserializeFrom(dict: jsonDic) else {
            showToastText(text: MoyaConfig.serverDataErrorText)
            completion?(nil)
            return
        }

        // 处理响应状态码
        if jsonData.code == responseSuccessCode {
            // 处理 CodeMsgModel 特殊情况
            let clsString = String(describing: type(of: jsonData))
            if clsString.contains(MoyaConfig.codeMsgModelIdentifier) && jsonData.data == nil {
                let m = CodeMsgModel()
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
