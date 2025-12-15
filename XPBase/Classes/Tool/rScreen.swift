//
//  LayoutConfig.swift
//  base
//
//  Created by 林小鹏 on 2021/12/7.
//  屏幕适配工具类：提供屏幕尺寸、安全区域、设备判断等相关配置

import Foundation
import GKNavigationBar
import UIKit

/// 屏幕适配相关工具结构体
public struct rScreen {
    /// 屏幕边界
    public static let bounds = UIScreen.main.bounds

    /// 屏幕宽度
    public static let width = bounds.size.width

    /// 屏幕高度
    public static let height = bounds.size.height

    /// 是否为刘海屏/全面屏（基于安全区域判断）
    public static var isFullScreen: Bool {
        if #available(iOS 11, *) {
            guard let window = UIApplication.window else {
                return false
            }

            // 通过安全区域判断是否为全面屏
            if window.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }

    /// 状态栏高度（兼容iOS13+）
    public static var statusHeight: CGFloat {
        if #available(iOS 13.0, *) {
            // iOS13+使用安全区域获取
            guard let window = UIApplication.shared.windows.first else {
                return 20.0
            }
            return window.safeAreaInsets.top
        } else {
            // iOS13以下使用传统方式
            return UIApplication.shared.statusBarFrame.height
        }
    }

    /// 导航栏内容高度（不包含状态栏）
    public static let naviBarHeight: CGFloat = 44

    /// 导航栏总高度（状态栏 + 导航栏）
    public static var navigationBarHeight: CGFloat {
        return statusHeight + naviBarHeight
    }

    /// 底部标签栏高度（包含安全区域）
    public static var tabBarHeight: CGFloat {
        return isFullScreen ? 49 + safeAreaBottom : 49
    }

    /// 底部安全区域高度
    public static var safeAreaBottom: CGFloat {
        guard let window = UIApplication.window else {
            return 0
        }
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.bottom
        }
        return 0
    }

    /// 顶部安全区域高度
    public static var safeAreaTop: CGFloat {
        guard let window = UIApplication.window else {
            return 0
        }
        if #available(iOS 11.0, *) {
            return window.safeAreaInsets.top
        }
        return 0
    }

    // MARK: - GKNavigationBar相关高度（如不使用可删除）

    /// 状态栏高度（GK库版本）
    public static let statusGKHeight: CGFloat = UIDevice.statusBarHeightForPortrait

    /// 导航栏总高度（GK库版本）
    public static let navigationGKBarHeight: CGFloat = statusGKHeight + naviBarHeight
}

// MARK: - 辅助扩展

extension UIApplication {
    /// 获取应用当前活跃场景的关键窗口
    static var window: UIWindow? {
        if #available(iOS 15.0, *) {
            // iOS 15+：从活跃的窗口场景中获取关键窗口
            let activeScenes = UIApplication.shared.connectedScenes
                .filter {
                    $0.activationState == .foregroundActive
                }
                .compactMap { $0 as? UIWindowScene }

            // 优先返回当前活跃场景中的关键窗口
            for scene in activeScenes {
                if let keyWindow = scene.keyWindow {
                    return keyWindow
                }
            }
            // 如果活跃场景没有关键窗口，则返回其第一个窗口
            for scene in activeScenes {
                if let window = scene.windows.first {
                    return window
                }
            }
            return nil
        } else {
            // iOS 15 之前：回退到旧的 API
            #if swift(>=5.1)
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            #else
                return UIApplication.shared.keyWindow
            #endif
        }
    }
}

// MARK: - 设备类型判断（基于屏幕高度，可根据需求保留或删除）

extension rScreen {
    /// 设备类型枚举
    public enum DeviceType {
        case iPhone4 // 3.5寸
        case iPhone5 // 4寸
        case iPhone6 // 4.7寸
        case iPhone6P // 5.5寸
        case iPhoneX // 5.8寸
        case other
    }

    /// 获取当前设备类型
    public static var deviceType: DeviceType {
        switch height {
        case 480 ... 568: // 3.5-4寸
            return height < 568 ? .iPhone4 : .iPhone5
        case 667: // 4.7寸
            return .iPhone6
        case 736: // 5.5寸
            return .iPhone6P
        case 812...: // 5.8寸及以上
            return .iPhoneX
        default:
            return .other
        }
    }

    // 废弃的重复功能（已整合到deviceType）
    // @available(*, deprecated, message: "请使用 rScreen.deviceType == .iPhone6 替代")
    // public static let iPhone6 = rScreen.height == 667 ? true : false
}
