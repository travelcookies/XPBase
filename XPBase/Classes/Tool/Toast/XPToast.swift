//
//  XPToast.swift
//
//  Created by 林小鹏 on 2022/10/18.
//

import UIKit
import Toast_Swift

/// 显示Toast提示框（XP 命名空间版本）
/// 在屏幕中央显示一段文本提示，默认持续2秒
///
/// 使用示例：
/// ```swift
/// // 显示普通提示
/// XPToast.show(text: "操作成功")
///
/// // 显示错误提示
/// XPToast.show(text: "网络请求失败，请稍后重试")
/// ```
/// - Parameter text: 要显示的提示文本
public func showToastText(text: String) {
    if text == "" {
        return
    }
    XPRootViewControllerManager.keyWindow()?.makeToast(text, duration: 2.0, position: .center)
}

/// Toast 工具类（XP 命名空间版本）
/// 提供统一的 Toast 提示能力
public struct XPToast {
    
    /// 显示Toast提示框
    /// - Parameters:
    ///   - text: 要显示的提示文本
    ///   - duration: 显示时长（默认2秒）
    public static func show(text: String, duration: TimeInterval = 2.0) {
        if text.isEmpty {
            return
        }
        XPRootViewControllerManager.keyWindow()?.makeToast(text, duration: duration, position: .center)
    }
    
    /// 显示Toast提示框（带位置参数）
    /// - Parameters:
    ///   - text: 要显示的提示文本
    ///   - position: 显示位置
    ///   - duration: 显示时长（默认2秒）
    public static func show(text: String, position: ToastPosition, duration: TimeInterval = 2.0) {
        if text.isEmpty {
            return
        }
        XPRootViewControllerManager.keyWindow()?.makeToast(text, duration: duration, position: position)
    }
}

/// 判断当前网络连接状态（XP 命名空间版本）
///
/// 使用示例：
/// ```swift
/// // 在发起网络请求前检查网络状态
/// if networkStatusJudgment() {
///     // 网络可用，执行请求
///     fetchData()
/// } else {
///     // 网络不可用，提示用户
///     XPToast.show(text: "请检查您的网络连接")
/// }
/// ```
/// - Returns: `true` 表示网络可用，`false` 表示网络不可用
public func networkStatusJudgment() -> Bool {
    let isUse = XPReachableManager.shared.stateUseless
    return !isUse
}