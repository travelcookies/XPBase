//
//  XPCompatible.swift
//  RSwiftBase
//
//  Created by 林小鹏 on 2022/7/16.
//

import Foundation

/// XP 命名空间包装结构体
/// 用于为任意类型添加扩展方法，实现优雅的链式调用
///
/// 使用示例：
/// ```swift
/// // 让类型遵循 XPCompatible 协议
/// extension UIView: XPCompatible {}
///
/// // 在扩展中使用 XP 命名空间添加方法
/// public extension XP where Base == UIView {
///     func addCorner(radius: CGFloat) {
///         base.layer.cornerRadius = radius
///         base.clipsToBounds = true
///     }
/// }
///
/// // 使用扩展方法
/// let view = UIView()
/// view.xp.addCorner(radius: 8)
/// ```
public struct XP<Base> {
    public let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

/// XP 兼容协议
/// 遵循此协议的类型将获得 `xp` 属性，用于访问 XP 命名空间下的扩展方法
public protocol XPCompatible {}

public extension XPCompatible {
    /// 类型级别 XP 命名空间入口
    static var xp: XP<Self>.Type {
        get { XP<Self>.self }
        set {}
    }

    /// 实例级别 XP 命名空间入口
    var xp: XP<Self> {
        get { XP(self) }
        set {}
    }
}
