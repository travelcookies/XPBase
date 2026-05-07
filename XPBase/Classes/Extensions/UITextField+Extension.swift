//
//  TextFieldExtension.swift
//  RSwiftBase
//
//  Created by 林小鹏 on 2022/11/30.
//

import UIKit

/// UITextField 扩展（XP命名空间版本）
/// 提供文本输入框相关的便捷方法
///
/// 使用示例：
/// ```swift
/// let textField = UITextField()
/// 
/// // 设置左边空白区域
/// textField.xp.setTextFieldNormalLeftV() // 使用默认尺寸
/// textField.xp.setTextFieldNormalLeftV(size: CGSize(width: 15, height: 30)) // 自定义尺寸
/// ```
public extension XP where Base == UITextField {
    /// 设置左边空白区域
    /// - Parameter size: 空白区域的尺寸，默认 CGSize(width: 20, height: 30)
    func setTextFieldNormalLeftV(size: CGSize = CGSize(width: 20, height: 30)) {
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 35))
        base.leftView = leftV
        base.leftViewMode = .always
    }
}
