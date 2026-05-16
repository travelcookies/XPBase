//
//  XPReachableManager.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/16.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import Foundation
import Reachability
import SnapKit

/// 日志记录器
private let reachableLogger = XPLogger(category: "Network")

/// 网络可达性管理类（XP 命名空间版本）
/// 负责监听设备网络连接状态变化，并管理网络不可用提示视图的显示与隐藏
///
/// 使用示例：
/// ```swift
/// // 在 AppDelegate 或 SceneDelegate 中启动网络监听
/// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///     // 启动网络状态监听
///     XPReachableManager.shared.checkNetworkState()
///     return true
/// }
///
/// // 在业务代码中检查网络状态
/// func fetchData() {
///     if !XPReachableManager.shared.stateUseless {
///         // 网络可用，执行请求
///         // ...
///     } else {
///         // 网络不可用，提示用户
///         showToastText(text: "请检查网络连接")
///     }
/// }
///
/// // 监听网络状态变化（可选）
/// NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkChange), name: NSNotification.Name.reachabilityChanged, object: nil)
///
/// @objc func handleNetworkChange(notification: NSNotification) {
///     let isReachable = !XPReachableManager.shared.stateUseless
///     print("网络状态变化: \(isReachable ? "可用" : "不可用")")
/// }
/// ```
public class XPReachableManager {
    /// 网络不可用提示视图的实例
    var reachableManagerView: XPReachableManagerView?
    /// 标记当前提示视图是否正在显示，避免重复添加动画冲突
    var isShow: Bool = false

    /// 网络是否不可用
    /// 设置此属性会触发提示视图的显示或隐藏动画
    /// - Note: 当设置为 `true` 时，会显示网络不可用提示；设置为 `false` 时，会隐藏提示
    public var stateUseless: Bool = false {
        didSet {
            if stateUseless == true {
                // 网络变为不可用，需要显示提示
                if isShow == true {
                    return
                }
                reachableManagerView = XPReachableManagerView.initView()
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.delegate?.window ?? nil {
                    window.addSubview(reachableManagerView!)
                }
                reachableManagerView!.snp.makeConstraints { make in
                    make.top.equalTo(-100)
                    make.left.right.equalTo(0)
                    make.height.equalTo(XPScreen.isFullScreen == true ? 54 : 34)
                }

                UIView.animate(withDuration: 0.3) {
                    self.reachableManagerView!.snp.remakeConstraints { make in
                        make.left.right.top.equalTo(0)
                        make.height.equalTo(XPScreen.isFullScreen == true ? 54 : 34)
                    }
                    self.reachableManagerView?.superview!.layoutIfNeeded()
                }
                isShow = true
            } else {
                // 网络恢复可用，需要隐藏提示
                if isShow == false {
                    return
                }
                if reachableManagerView != nil {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.reachableManagerView!.snp.makeConstraints { make in
                            make.top.equalTo(-100)
                            make.left.right.equalTo(0)
                            make.height.equalTo(XPScreen.isFullScreen == true ? 54 : 34)
                        }
                        self.reachableManagerView?.superview!.layoutIfNeeded()
                    }) { _ in
                        self.reachableManagerView!.removeFromSuperview()
                    }
                }
                isShow = false
            }
        }
    }

    /// 单例实例，提供全局访问点
    public static let shared = XPReachableManager()
    /// 内部持有的Reachability监听器实例
    fileprivate var reachability: Reachability?

    /// 开始检查并监听网络状态
    /// 此方法初始化Reachability并启动状态监听
    public func checkNetworkState() {
        guard let reachability = try? Reachability() else { return }
        self.reachability = reachability

        reachability.whenReachable = { reach in
            switch reach.connection {
            case .wifi:
                reachableLogger.debug("Reachable via WiFi")
                self.stateUseless = false
            case .cellular:
                reachableLogger.debug("Reachable via Cellular")
                self.stateUseless = false
            case .unavailable:
                fallthrough
            default:
                reachableLogger.debug("Network not reachable")
                self.stateUseless = true
            }
        }

        reachability.whenUnreachable = { _ in
            reachableLogger.debug("Not reachable")
            self.stateUseless = true
        }

        do {
            try reachability.startNotifier()
        } catch {
            reachableLogger.error("Unable to start notifier: \(error.localizedDescription)")
        }
    }

    deinit {
        reachableLogger.debug("reachability.stopNotifier()")
        reachability?.stopNotifier()
    }
}
