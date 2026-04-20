//
//  UIButton+Extension.swift
//  XPBase
//
//  Created by 林小鹏 on 2022/7/16.
//

import Foundation
import UIKit

/// 使用方法示例：
/// ```swift
/// // 设置按钮图文混排 - 内容居中-图上文下
/// button.xp.contentLayout(.centerImageTop, 8, periphery: 16)
/// 
/// // 设置按钮图文混排 - 内容居中-图左文右
/// button.xp.contentLayout(.normal, 8, periphery: 16)
/// 
/// // 设置按钮图文混排 - 内容居左-图左文右
/// button.xp.contentLayout(.leftImageLeft, 8, periphery: 16)
/// ```

public extension XP where Base == UIButton {
    enum ButtonContentLayoutStyle: Int {
        case normal = 0 // 内容居中-图左文右
        case centerImageRight // 内容居中-图右文左
        case centerImageTop // 内容居中-图上文下
        case centerImageBottom // 内容居中-图下文上
        case leftImageLeft // 内容居左-图左文右
        case leftImageRight // 内容居左-图右文左
        case rightImageLeft // 内容居右-图左文右
        case rightImageRight // 内容居右-图右文左
    }

    /// 设置图文混排
    /// - Parameters:
    ///   - layoutStyle: 图文混排样式
    ///   - padding: 图文间距
    ///   - periphery: 图文边界的间距
    func contentLayout(_ layoutStyle: ButtonContentLayoutStyle, _ padding: CGFloat, periphery: CGFloat) {
        base.imageView?.contentMode = .scaleToFill

        let imageWidth = base.imageView?.image?.size.width ?? 0.0
        let imageHeight = base.imageView?.image?.size.height ?? 0.0

        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0

        if #available(iOS 8.0, *) {
            labelWidth = base.titleLabel?.intrinsicContentSize.width ?? 0.0
            labelHeight = base.titleLabel?.intrinsicContentSize.height ?? 0.0
        } else {
            labelWidth = base.titleLabel?.frame.size.width ?? 0.0
            labelHeight = base.titleLabel?.frame.size.height ?? 0.0
        }

        var imageEdge = UIEdgeInsets.zero
        var titleEdge = UIEdgeInsets.zero

        switch layoutStyle {
        case .normal:
            titleEdge = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: 0)
            imageEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding)
            base.contentHorizontalAlignment = .center

        case .centerImageRight:
            titleEdge = UIEdgeInsets(top: 0, left: -imageWidth - padding, bottom: 0, right: imageWidth)
            imageEdge = UIEdgeInsets(top: 0, left: labelWidth + padding, bottom: 0, right: -labelWidth)
            base.contentHorizontalAlignment = .center

        case .centerImageTop:
            titleEdge = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - padding, right: 0)
            imageEdge = UIEdgeInsets(top: -labelHeight - padding, left: 0, bottom: 0, right: -labelWidth)
            base.contentHorizontalAlignment = .center

        case .centerImageBottom:
            titleEdge = UIEdgeInsets(top: -imageHeight - padding, left: -imageWidth, bottom: 0, right: 0)
            imageEdge = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - padding, right: -labelWidth)
            base.contentHorizontalAlignment = .center

        case .leftImageLeft:
            titleEdge = UIEdgeInsets(top: 0, left: padding + periphery, bottom: 0, right: 0)
            imageEdge = UIEdgeInsets(top: 0, left: periphery, bottom: 0, right: 0)
            base.contentHorizontalAlignment = .left

        case .leftImageRight:
            titleEdge = UIEdgeInsets(top: 0, left: -imageWidth + periphery, bottom: 0, right: 0)
            imageEdge = UIEdgeInsets(top: 0, left: labelWidth + padding + periphery, bottom: 0, right: 0)
            base.contentHorizontalAlignment = .left

        case .rightImageLeft:
            titleEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: padding + periphery)
            imageEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: periphery)
            base.contentHorizontalAlignment = .right

        case .rightImageRight:
            titleEdge = UIEdgeInsets(top: 0, left: -base.frame.size.width / 2, bottom: 0, right: imageWidth + padding + periphery)
            imageEdge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -labelWidth + periphery)
            base.contentHorizontalAlignment = .right
        }

        base.imageEdgeInsets = imageEdge
        base.titleEdgeInsets = titleEdge
        base.setNeedsDisplay()
    }
}


