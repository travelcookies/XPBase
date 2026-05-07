import Foundation
import UIKit

/// 颜色工具类（XP命名空间版本）
/// 提供便捷的颜色创建方法，支持RGB、十六进制整数、十六进制字符串等多种方式
///
/// 使用示例：
/// ```swift
/// // 使用RGB值创建颜色（不透明）
/// let redColor = XPColor.rgb(r: 255, g: 0, b: 0)
/// 
/// // 使用RGB值创建颜色（带透明度）
/// let transparentRed = XPColor.rgba(r: 255, g: 0, b: 0, a: 0.5)
/// 
/// // 使用十六进制整数创建颜色（不透明）
/// let blueColor = XPColor.hex(hexValue: 0x0000FF)
/// 
/// // 使用十六进制整数创建颜色（带透明度）
/// let transparentBlue = XPColor.hexa(hexValue: 0x0000FF, a: 0.5)
/// 
/// // 使用十六进制字符串创建颜色（不透明）
/// let greenColor = XPColor.hex("#00FF00")
/// let greenColorNoHash = XPColor.hex("00FF00") // 不带#号也可以
/// 
/// // 使用十六进制字符串创建颜色（带透明度）
/// let transparentGreen = XPColor.hexa("#00FF00", alpha: 0.5)
/// ```
public struct XPColor {
    public static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    public static func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    public static func hexa(hexValue: Int, a: CGFloat) -> UIColor {
        return UIColor(red: (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0,
                       green: (CGFloat)((hexValue & 0xFF00) >> 8) / 255.0,
                       blue: (CGFloat)(hexValue & 0xFF) / 255.0,
                       alpha: a)
    }
    
    public static func hex(hexValue: Int) -> UIColor {
        return hexa(hexValue: hexValue, a: 1.0)
    }
    
    public static func hex(_ hexString: String) -> UIColor {
        let hex = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public static func hexa(_ hexString: String, alpha: CGFloat) -> UIColor {
        let hex = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}