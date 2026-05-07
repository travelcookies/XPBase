import Foundation
import UIKit

/// 字体工具类（XP命名空间版本）
/// 提供便捷的字体创建方法
///
/// 使用示例：
/// ```swift
/// // 创建系统字体（常规字重）
/// let font = XPFont.font(16)
/// 
/// // 创建指定字重的系统字体
/// let mediumFont = XPFont.font(16, .medium)
/// let boldFont = XPFont.font(18, .bold)
/// 
/// // 创建粗体字体
/// let boldTextFont = XPFont.bold(16)
/// 
/// // 创建斜体字体
/// let italicFont = XPFont.italic(16)
/// ```
public struct XPFont {
    public static func font(_ size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    public static func font(_ size: CGFloat, _ weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    public static func bold(_ size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    public static func italic(_ size: CGFloat) -> UIFont {
        return UIFont.italicSystemFont(ofSize: size)
    }
}