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

extension UIDevice {
    /// 获取设备型号标识符
    var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
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
        case iPhoneXSMax // 6.5寸
        case iPhone11 // 6.1寸
        case iPhone12Mini // 5.4寸
        case iPhone12 // 6.1寸
        case iPhone12ProMax // 6.7寸
        case iPhone13Mini // 5.4寸
        case iPhone13 // 6.1寸
        case iPhone13ProMax // 6.7寸
        case iPhone14 // 6.1寸
        case iPhone14Plus // 6.7寸
        case iPhone14Pro // 6.1寸
        case iPhone14ProMax // 6.7寸
        case iPhone15 // 6.1寸
        case iPhone15Plus // 6.7寸
        case iPhone15Pro // 6.1寸
        case iPhone15ProMax // 6.7寸
        case iPhone16 // 6.1寸
        case iPhone16Plus // 6.7寸
        case iPhone16Pro // 6.1寸
        case iPhone16ProMax // 6.7寸
        case iPhone17 // 6.1寸
        case iPhone17Plus // 6.7寸
        case iPhone17Pro // 6.1寸
        case iPhone17ProMax // 6.7寸
        case other
    }

    /// 获取当前设备类型
    public static var deviceType: DeviceType {
        // 首先尝试通过设备型号判断
        let deviceModel = UIDevice.current.modelIdentifier
        
        // 根据设备型号判断
        switch deviceModel {
        // iPhone 4 系列
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return .iPhone4
        // iPhone 5 系列
        case "iPhone5,1", "iPhone5,2":
            return .iPhone5
        case "iPhone5,3", "iPhone5,4":
            return .iPhone5
        // iPhone 6 系列
        case "iPhone7,2":
            return .iPhone6
        case "iPhone7,1":
            return .iPhone6P
        // iPhone X 系列
        case "iPhone10,1", "iPhone10,4":
            return .iPhoneX
        case "iPhone10,2", "iPhone10,5":
            return .iPhoneXSMax
        // iPhone 11 系列
        case "iPhone12,1":
            return .iPhone11
        case "iPhone12,5":
            return .iPhone11
        // iPhone 12 系列
        case "iPhone13,1":
            return .iPhone12Mini
        case "iPhone13,2":
            return .iPhone12
        case "iPhone13,3":
            return .iPhone12
        case "iPhone13,4":
            return .iPhone12ProMax
        // iPhone 13 系列
        case "iPhone14,4":
            return .iPhone13Mini
        case "iPhone14,5":
            return .iPhone13
        case "iPhone14,2":
            return .iPhone13
        case "iPhone14,3":
            return .iPhone13ProMax
        // iPhone 14 系列
        case "iPhone14,7":
            return .iPhone14
        case "iPhone14,8":
            return .iPhone14Plus
        case "iPhone15,2":
            return .iPhone14Pro
        case "iPhone15,3":
            return .iPhone14ProMax
        // iPhone 15 系列
        case "iPhone15,4":
            return .iPhone15
        case "iPhone15,5":
            return .iPhone15Plus
        case "iPhone16,1":
            return .iPhone15Pro
        case "iPhone16,2":
            return .iPhone15ProMax
        // iPhone 16 系列
        case "iPhone16,6":
            return .iPhone16
        case "iPhone16,7":
            return .iPhone16Plus
        case "iPhone17,2":
            return .iPhone16Pro
        case "iPhone17,3":
            return .iPhone16ProMax
        // iPhone 17 系列
        case "iPhone17,6":
            return .iPhone17
        case "iPhone17,7":
            return .iPhone17Plus
        case "iPhone18,2":
            return .iPhone17Pro
        case "iPhone18,3":
            return .iPhone17ProMax
        default:
            // 如果无法通过设备型号判断，回退到屏幕高度判断
            return deviceTypeByScreenHeight
        }
    }
    
    /// 根据屏幕高度判断设备类型（备用方法）
    private static var deviceTypeByScreenHeight: DeviceType {
        switch height {
        case 480: // 3.5寸
            return .iPhone4
        case 568: // 4寸
            return .iPhone5
        case 667: // 4.7寸
            return .iPhone6
        case 736: // 5.5寸
            return .iPhone6P
        case 812: // 5.8寸
            return .iPhoneX
        case 896: // 6.1寸 (iPhone 11, 12, 13, 14, 15, 16, 17)
            return .iPhone11
        case 844: // 5.4寸 (iPhone 12 Mini, 13 Mini)
            return .iPhone12Mini
        case 926: // 6.7寸 (iPhone 12 Pro Max, 13 Pro Max, 14 Plus, 14 Pro Max, 15 Plus, 15 Pro Max, 16 Plus, 16 Pro Max, 17 Plus, 17 Pro Max)
            return .iPhone12ProMax
        case 852: // 6.1寸 (iPhone 14 Pro, 15 Pro, 16 Pro, 17 Pro)
            return .iPhone14Pro
        default:
            return .other
        }
    }

    // 废弃的重复功能（已整合到deviceType）
    // @available(*, deprecated, message: "请使用 rScreen.deviceType == .iPhone6 替代")
    // public static let iPhone6 = rScreen.height == 667 ? true : false
}
