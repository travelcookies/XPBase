import UIKit

/// 应用信息工具类（已整合到XPDevice，此文件保留以兼容旧代码）
@available(*, deprecated, message: "Use XPDevice instead")
public struct XPAppInfo {
    public static var appName: String {
        return XPDevice.shared.appName
    }
    
    public static var appVersion: String {
        return XPDevice.shared.appVersion
    }
    
    public static var buildVersion: String {
        return XPDevice.shared.appBuildVersion
    }
    
    public static var systemVersion: Double {
        return Double(XPDevice.shared.sysVersion) ?? 0
    }
    
    public static var deviceUUID: String {
        return XPDevice.shared.deviceUUID ?? ""
    }
    
    public static var deviceModel: String {
        return XPDevice.shared.name
    }
    
    public static var bundleIdentifier: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
}