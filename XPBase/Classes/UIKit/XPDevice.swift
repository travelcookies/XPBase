import Foundation
import UIKit

/// 设备信息工具类（XP命名空间版本）
/// 提供设备相关信息的获取方法，包括设备型号、系统版本、应用信息等
///
/// 使用示例：
/// ```swift
/// // 获取设备名称
/// let deviceName = XPDevice.share.name // 如 "iPhone 13"
/// 
/// // 获取设备显示名称
/// let displayName = XPDevice.share.deviceName // 如 "张三的 iPhone"
/// 
/// // 获取系统名称
/// let systemName = XPDevice.share.sysName // "iOS"
/// 
/// // 获取系统版本
/// let systemVersion = XPDevice.share.sysVersion // "15.0"
/// 
/// // 获取设备UUID
/// let uuid = XPDevice.share.deviceUUID
/// 
/// // 获取设备型号
/// let model = XPDevice.share.deviceModel // "iPhone"
/// 
/// // 获取应用版本号
/// let appVersion = XPDevice.share.appVersion // "1.0.0"
/// 
/// // 获取应用构建版本
/// let buildVersion = XPDevice.share.appBuildVersion // "1"
/// 
/// // 获取应用名称
/// let appName = XPDevice.share.appName // "MyApp"
/// ```
public struct XPDevice {
    public static let share = XPDevice()
    
    public let name: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1": return "iPod Touch 5"
        case "iPod7,1": return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return "iPhone 4"
        case "iPhone4,1": return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2": return "iPhone 5"
        case "iPhone5,3", "iPhone5,4": return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2": return "iPhone 5s"
        case "iPhone7,2": return "iPhone 6"
        case "iPhone7,1": return "iPhone 6 Plus"
        case "iPhone8,1": return "iPhone 6s"
        case "iPhone8,2": return "iPhone 6s Plus"
        case "iPhone9,1": return "iPhone 7"
        case "iPhone9,2": return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4": return "iPhone 8"
        case "iPhone10,2", "iPhone10,5": return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6": return "iPhone X"
        case "iPhone11,2": return "iPhone XS"
        case "iPhone11,6": return "iPhone XS MAX"
        case "iPhone11,8": return "iPhone XR"
        case "iPhone12,1": return "iPhone 11"
        case "iPhone12,3": return "iPhone 11 Pro"
        case "iPhone12,5": return "iPhone 11 Pro MAX"
        case "iPhone13,1": return "iPhone 12 mini"
        case "iPhone13,2": return "iPhone 12"
        case "iPhone13,3": return "iPhone 12 Pro"
        case "iPhone13,4": return "iPhone 12 Pro MAX"
        case "iPhone14,4": return "iPhone 13 mini"
        case "iPhone14,5": return "iPhone 13"
        case "iPhone14,2": return "iPhone 13 Pro"
        case "iPhone14,3": return "iPhone 13 Pro Max"
        case "iPhone14,6": return "iPhone SE (3rd generation)"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3": return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6": return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3": return "iPad Air"
        case "iPad5,3", "iPad5,4": return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7": return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6": return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9": return "iPad Mini 3"
        case "iPad5,1", "iPad5,2": return "iPad Mini 4"
        case "iPad6,7", "iPad6,8": return "iPad Pro"
        case "iPad6,3", "iPad6,4": return "iPad Pro (9.7-inch)"
        case "iPad7,1", "iPad7,2": return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,4", "iPad7,3": return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,9", "iPad8,10": return "iPad Pro (11-inch) (2nd generation)"
        case "iPad8,11", "iPad8,12": return "iPad Pro (12.9-inch) (4th generation)"
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return "iPad Pro (11-inch) (3rd generation)"
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return "iPad Pro (12.9-inch) (5th generation)"
        case "AppleTV5,3": return "Apple TV"
        case "i386", "x86_64": return "Simulator"
        default: return identifier
        }
    }()
    
    public let deviceName = UIDevice.current.name
    
    public let sysName = UIDevice.current.systemName
    
    public let sysVersion = UIDevice.current.systemVersion
    
    public let deviceUUID = UIDevice.current.identifierForVendor?.uuidString
    
    public let deviceModel = UIDevice.current.model
    
    public var infoDic = Bundle.main.infoDictionary
    
    public var appVersion: String {
        infoDic?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    public var appBuildVersion: String {
        infoDic?["CFBundleVersion"] as? String ?? ""
    }
    
    public var appName: String {
        infoDic?["CFBundleDisplayName"] as? String ?? ""
    }
}