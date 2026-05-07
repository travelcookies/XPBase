//
//  UIAlertController+Extention.swift
//  XPBase
//
//  Created by 林小鹏 on 2026/4/20.
//

import Foundation
import UIKit

/// 使用方法示例：
/// ```swift
/// // 创建并显示简单警告框
/// let alert = UIAlertController.xp.alert(title: "提示", message: "操作成功", okAction: {
///     print("用户点击了确定")
/// })
/// alert.xp.show(in: self)
/// 
/// // 创建并显示带取消按钮的警告框
/// let confirmAlert = UIAlertController.xp.alertWithCancel(
///     title: "确认", 
///     message: "确定要删除这个项目吗？", 
///     okAction: {
///         print("用户点击了确定，执行删除操作")
///     }, 
///     cancelAction: {
///         print("用户点击了取消，取消删除操作")
///     }
/// )
/// confirmAlert.xp.show(in: self)
/// 
/// // 创建并显示带输入框的警告框
/// let inputAlert = UIAlertController.xp.alertWithInput(
///     title: "输入", 
///     message: "请输入您的姓名", 
///     placeholder: "请输入姓名", 
///     okAction: { text in
///         print("用户输入了：\(text)")
///     }
/// )
/// inputAlert.xp.show(in: self)
/// ```

public extension XP where Base == UIAlertController {
    /// 创建简单的警告框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - okTitle: 确定按钮标题
    ///   - okAction: 确定按钮回调
    /// - Returns: UIAlertController
    static func alert(title: String?, message: String?, okTitle: String = "确定", okAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okAction?()
        }
        alert.addAction(okAction)
        return alert
    }
    
    /// 创建带取消按钮的警告框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - okTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮标题
    ///   - okAction: 确定按钮回调
    ///   - cancelAction: 取消按钮回调
    /// - Returns: UIAlertController
    static func alertWithCancel(title: String?, message: String?, okTitle: String = "确定", cancelTitle: String = "取消", okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okAction?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }
    
    /// 创建带输入框的警告框
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 消息
    ///   - placeholder: 输入框占位符
    ///   - okTitle: 确定按钮标题
    ///   - cancelTitle: 取消按钮标题
    ///   - okAction: 确定按钮回调，包含输入内容
    ///   - cancelAction: 取消按钮回调
    /// - Returns: UIAlertController
    static func alertWithInput(title: String?, message: String?, placeholder: String?, okTitle: String = "确定", cancelTitle: String = "取消", okAction: ((String) -> Void)? = nil, cancelAction: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = placeholder
        }
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                okAction?(text)
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        return alert
    }
    
    /// 显示警告框
    /// - Parameter viewController: 显示警告框的视图控制器
    func show(in viewController: UIViewController) {
        viewController.present(base, animated: true, completion: nil)
    }
}

