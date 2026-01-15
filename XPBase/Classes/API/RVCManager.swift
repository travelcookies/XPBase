//
//  RVCManager.swift
//
//  Created by 林小鹏 on 2022/10/18.
//  Copyright © 2022 ningbokubin. All rights reserved.
//

import UIKit

/// 视图控制器管理器，用于获取当前显示的视图控制器
public final class RVCManager {

    /// 获取当前显示的视图控制器
    /// - Returns: 当前最顶层的视图控制器
    public class func currentViewController() -> UIViewController? {
        guard let rootViewController = keyWindow()?.rootViewController else {
            return nil
        }
        return getCurrentViewController(from: rootViewController)
    }

    /// 当前显示的视图控制器（计算属性版本）
    public static var currentVC: UIViewController? {
        guard let rootViewController = keyWindow()?.rootViewController else {
            return nil
        }
        return getCurrentViewController(from: rootViewController)
    }

    /// 获取应用的主窗口
    /// - Returns: 应用的主窗口，如果不存在则返回 nil
    public class func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    // MARK: - Private Methods

    /// 递归获取当前显示的视图控制器
    /// - Parameter rootViewController: 根视图控制器
    /// - Returns: 当前显示的视图控制器
    private class func getCurrentViewController(from rootViewController: UIViewController) -> UIViewController {
        var currentViewController = rootViewController

        // 处理 presented 视图控制器
        if let presentedViewController = currentViewController.presentedViewController {
            currentViewController = presentedViewController
        }

        // 根据视图控制器类型递归获取
        switch currentViewController {
        case let tabBarController as UITabBarController:
            if let selectedViewController = tabBarController.selectedViewController {
                return getCurrentViewController(from: selectedViewController)
            }

        case let navigationController as UINavigationController:
            if let visibleViewController = navigationController.visibleViewController {
                return getCurrentViewController(from: visibleViewController)
            }

        default:
            break
        }

        return currentViewController
    }

    /// 获取当前导航控制器
    /// - Returns: 当前显示的导航控制器，如果不存在则返回 nil
    public class func currentNavigationController() -> UINavigationController? {
        return currentViewController()?.navigationController
    }

    /// 获取当前标签页控制器
    /// - Returns: 当前显示的标签页控制器，如果不存在则返回 nil
    public class func currentTabBarController() -> UITabBarController? {
        return currentViewController()?.tabBarController
    }

    /// 安全获取当前视图控制器（带后备值）
    /// - Parameter fallback: 当无法获取当前视图控制器时返回的后备视图控制器
    /// - Returns: 当前视图控制器或后备视图控制器
    public class func safeCurrentViewController(fallback: UIViewController? = nil) -> UIViewController {
        return currentViewController() ?? fallback ?? UIViewController()
    }
}
