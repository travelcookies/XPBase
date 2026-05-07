//
//  Int+Extension.swift
//  YiShouKuan
//
//  Created by nbfujx on 2019/7/12.
//  Copyright © 2019 ningbokubin. All rights reserved.
//

import UIKit

/// Int 扩展（XP命名空间版本）
/// 提供整数相关的便捷属性和方法，包括金额转换、时间格式化、颜色转换等
///
/// 使用示例：
/// ```swift
/// // 金额转换（分转元）
/// let amountInFen = 1234 // 12.34元
/// let amountStr = amountInFen.xp.fen2YuanDecimalFormatterValue() // "12.34"
/// 
/// // 时间格式化（秒转时分秒）
/// let seconds = 3661 // 1小时1分钟1秒
/// let timeStr = seconds.xp.timeToStringFormatterValue() // "1小时1分钟1秒"
/// 
/// // 整数转颜色
/// let colorInt = 0xFF0000 // 红色
/// let color = colorInt.xp.hex // UIColor(red: 1, green: 0, blue: 0, alpha: 1)
/// let transparentColor = colorInt.xp.hexa(0.5) // 带透明度的红色
/// ```
extension Int: XPCompatible {}

public extension XP where Base == Int {
    /// 金额转换：分转元，返回格式化后的字符串
    /// - Returns: 格式化后的金额字符串，如 "12.34"
    @discardableResult func fen2YuanDecimalFormatterValue() -> String? {
        let decimal = base % 100
        let nonDecimal = base / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let title = formatter.string(from: NSNumber(value: nonDecimal)) {
            return title + String(format: ".%02d", decimal)
        }
        return nil
    }

    /// 时分秒 转 String
    /// - Returns: String
    func timeToStringFormatterValue() -> String {
        if base < 60 {
            return String(format: "%d秒", base)
        }
        if base >= 60 && base < 60 * 60 {
            return String(format: "%d分钟%d秒", base / 60, base % 60)
        }
        if base >= 60 * 60 {
            return String(format: "%d小时%d分钟%d秒", base / (60 * 60), (base % (60 * 60)) / 60, base % 60)
        }
        return "0秒"
    }
}

/// Color
public extension XP where Base == Int {
    /// 16位 颜色设置
    /// - Returns: UIColor
    var hex: UIColor {
        hexa(1.0)
    }

    func hexa(_ a: CGFloat) -> UIColor {
        UIColor(red: (CGFloat)((base & 0xFF0000) >> 16) / 255.0,
                green: (CGFloat)((base & 0xFF00) >> 8) / 255.0,
                blue: (CGFloat)(base & 0xFF) / 255.0,
                alpha: a)
    }
}
