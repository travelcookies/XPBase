import UIKit

/// 应用信息工具类（XP命名空间版本）
/// 提供获取应用基本信息的便捷方法，包括应用名称、版本号、设备信息等
///
/// 使用示例：
/// ```swift
/// // 获取应用名称
/// let appName = XPAppInfo.appName
/// 
/// // 获取应用版本号
/// let version = XPAppInfo.appVersion
/// 
/// // 获取构建版本号
/// let build = XPAppInfo.buildVersion
/// 
/// // 获取系统版本
/// let systemVersion = XPAppInfo.systemVersion
/// 
/// // 获取设备UUID
/// let uuid = XPAppInfo.deviceUUID
/// 
/// // 获取设备型号标识符
/// let model = XPAppInfo.deviceModel
/// 
/// // 获取Bundle标识符
/// let bundleID = XPAppInfo.bundleIdentifier
/// ```
public struct XPAppInfo {
    /// 应用名称（CFBundleDisplayName）
    public static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    
    /// 应用版本号（CFBundleShortVersionString）
    public static var appVersion: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /// 构建版本号（CFBundleVersion）
    public static var buildVersion: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    /// 系统版本号
    public static var systemVersion: Double {
        return Double(UIDevice.current.systemVersion) ?? 0
    }
    
    /// 设备UUID（identifierForVendor）
    public static var deviceUUID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    /// 设备型号标识符（如 iPhone16,1）
    public static var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
    
    /// Bundle标识符
    public static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}