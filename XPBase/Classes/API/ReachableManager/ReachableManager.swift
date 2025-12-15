//
//  ReachableManager.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/16.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import Foundation
import Reachability // 引入第三方网络状态监测库

/// 网络可达性管理类
/// 1. 负责监听设备网络连接状态变化（通过Reachability库）
/// 2. 管理一个全局的网络不可用提示视图（ReachableManagerView）的显示与隐藏
class ReachableManager {

    /// 网络不可用提示视图的实例
    var reachableManagerView: ReachableManagerView?
    /// 标记当前提示视图是否正在显示，避免重复添加动画冲突
    var isShow: Bool = false

    /// 外部可设置属性：网络是否"不可用"
    /// 设置此属性会触发提示视图的显示或隐藏动画
    /// 注意：此属性名`stateUseless`意为“状态不可用”，易产生歧义，建议可重命名为类似 `isNetworkUnreachable` 以明确表示“网络不可达”
    var stateUseless: Bool = false {
        didSet {
            if stateUseless == true {
                // 网络变为不可用，需要显示提示
                if isShow == true { // 如果已经显示，则直接返回，防止重复执行动画
                    return
                }
                // 初始化并添加提示视图到窗口
                reachableManagerView = ReachableManagerView.initView()
                UIApplication.shared.keyWindow?.addSubview(reachableManagerView!)
                // 使用SnapKit布局：初始位置在屏幕顶部之外
                reachableManagerView!.snp.makeConstraints { (make) in
                    make.top.equalTo(-100)
                    make.left.right.equalTo(0)
                    // 根据是否为全面屏设备调整视图高度（适配刘海屏）
                    make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                }

                // 执行入场动画：将视图从顶部滑入
                UIView.animate(withDuration: 0.3) {
                    self.reachableManagerView!.snp.remakeConstraints { (make) in
                        make.left.right.top.equalTo(0)
                        make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                    }
                    self.reachableManagerView?.superview!.layoutIfNeeded()
                }
                isShow = true
            } else {
                // 网络恢复可用，需要隐藏提示
                if isShow == false { // 如果已经隐藏，则直接返回
                    return
                }
                if reachableManagerView != nil {
                    // 执行退场动画：将视图滑出到屏幕顶部之外
                    UIView.animate(withDuration: 0.3, animations: {
                        self.reachableManagerView!.snp.makeConstraints { (make) in
                            make.top.equalTo(-100)
                            make.left.right.equalTo(0)
                            make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                        }
                        self.reachableManagerView?.superview!.layoutIfNeeded()
                    }) { (_) in
                        // 动画完成后，从视图层级中移除
                        self.reachableManagerView!.removeFromSuperview()
                    }
                }
                isShow = false
            }
        }
    }

    /// 单例实例，提供全局访问点
    static let shared = ReachableManager()
    /// 内部持有的Reachability监听器实例（文件私有，限制外部直接访问）
    fileprivate var reachability: Reachability?

    /// 开始检查并监听网络状态
    /// 此方法初始化Reachability并启动状态监听
    func checkNetworkState() {
        // 尝试初始化Reachability（可能失败，例如在模拟器某些配置下）
        guard let reachability = try? Reachability() else { return }
        self.reachability = reachability

        // 设置网络可达时的回调
        reachability.whenReachable = { reach in
            switch reach.connection {
            case .wifi:
                print("Reachable via WiFi")
                self.stateUseless = false // 网络恢复，更新状态（触发隐藏提示）
            case .cellular:
                print("Reachable via Cellular")
                self.stateUseless = false // 网络恢复，更新状态
            case .unavailable:
                fallthrough // 如果不可用，则执行default分支
            default:
                // 通常不会执行到这里，因为.whenReachable回调时connection不应为.unavailable
                print("Network not reachable")
                self.stateUseless = true
            }
        }
        // 设置网络不可达时的回调
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.stateUseless = true // 网络断开，更新状态（触发显示提示）
        }

        // 尝试启动监听器
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    /// 析构函数
    /// 当ReachableManager实例被销毁时，停止网络状态监听以释放资源
    deinit {
        print("reachability.stopNotifier()")
        reachability?.stopNotifier()
    }
}
