import Foundation

/// 设备型号配置
/// 存储设备标识符与设备名称的映射关系，便于维护和扩展
/// 
/// 使用示例：
/// ```swift
/// // 获取设备名称
/// let deviceName = XPDeviceModelConfiguration.deviceNames["iPhone16,1"] ?? "Unknown"
/// print(deviceName) // "iPhone 15 Pro"
/// 
/// // 获取安全区域配置
/// let insets = XPDeviceModelConfiguration.safeAreaInsetsDict["iPhone15,4"]?[.portrait]
/// ```
public struct XPDeviceModelConfiguration {
    
    /// 设备标识符到设备名称的映射
    public static let deviceNames: [String: String] = [
        // MARK: - iPhone
        "iPhone1,1": "iPhone 1G",
        "iPhone1,2": "iPhone 3G",
        "iPhone2,1": "iPhone 3GS",
        "iPhone3,1": "iPhone 4 (GSM)",
        "iPhone3,2": "iPhone 4",
        "iPhone3,3": "iPhone 4 (CDMA)",
        "iPhone4,1": "iPhone 4S",
        "iPhone5,1": "iPhone 5",
        "iPhone5,2": "iPhone 5",
        "iPhone5,3": "iPhone 5c",
        "iPhone5,4": "iPhone 5c",
        "iPhone6,1": "iPhone 5s",
        "iPhone6,2": "iPhone 5s",
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone7,2": "iPhone 6",
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",
        "iPhone8,4": "iPhone SE",
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,3": "iPhone 7",
        "iPhone9,4": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone10,4": "iPhone 8",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,6": "iPhone X",
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",
        "iPhone11,6": "iPhone XS Max CN",
        "iPhone11,8": "iPhone XR",
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8": "iPhone SE (2nd generation)",
        "iPhone13,1": "iPhone 12 mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,6": "iPhone SE (3rd generation)",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",
        "iPhone17,5": "iPhone 16e",
        "iPhone18,1": "iPhone 17 Pro",
        "iPhone18,2": "iPhone 17 Pro Max",
        "iPhone18,3": "iPhone 17",
        "iPhone18,4": "iPhone Air",
        
        // MARK: - iPad
        "iPad1,1": "iPad 1",
        "iPad2,1": "iPad 2 (WiFi)",
        "iPad2,2": "iPad 2 (GSM)",
        "iPad2,3": "iPad 2 (CDMA)",
        "iPad2,4": "iPad 2",
        "iPad2,5": "iPad mini 1",
        "iPad2,6": "iPad mini 1",
        "iPad2,7": "iPad mini 1",
        "iPad3,1": "iPad 3 (WiFi)",
        "iPad3,2": "iPad 3 (4G)",
        "iPad3,3": "iPad 3 (4G)",
        "iPad3,4": "iPad 4",
        "iPad3,5": "iPad 4",
        "iPad3,6": "iPad 4",
        "iPad4,1": "iPad Air",
        "iPad4,2": "iPad Air",
        "iPad4,3": "iPad Air",
        "iPad4,4": "iPad mini 2",
        "iPad4,5": "iPad mini 2",
        "iPad4,6": "iPad mini 2",
        "iPad4,7": "iPad mini 3",
        "iPad4,8": "iPad mini 3",
        "iPad4,9": "iPad mini 3",
        "iPad5,1": "iPad mini 4",
        "iPad5,2": "iPad mini 4",
        "iPad5,3": "iPad Air 2",
        "iPad5,4": "iPad Air 2",
        "iPad6,3": "iPad Pro (9.7 inch)",
        "iPad6,4": "iPad Pro (9.7 inch)",
        "iPad6,7": "iPad Pro (12.9 inch)",
        "iPad6,8": "iPad Pro (12.9 inch)",
        "iPad6,11": "iPad 5 (WiFi)",
        "iPad6,12": "iPad 5 (Cellular)",
        "iPad7,1": "iPad Pro (12.9 inch, 2nd generation)",
        "iPad7,2": "iPad Pro (12.9 inch, 2nd generation)",
        "iPad7,3": "iPad Pro (10.5 inch)",
        "iPad7,4": "iPad Pro (10.5 inch)",
        "iPad7,5": "iPad 6 (WiFi)",
        "iPad7,6": "iPad 6 (Cellular)",
        "iPad7,11": "iPad 7 (WiFi)",
        "iPad7,12": "iPad 7 (Cellular)",
        "iPad8,1": "iPad Pro (11 inch)",
        "iPad8,2": "iPad Pro (11 inch)",
        "iPad8,3": "iPad Pro (11 inch)",
        "iPad8,4": "iPad Pro (11 inch)",
        "iPad8,5": "iPad Pro (12.9 inch, 3rd generation)",
        "iPad8,6": "iPad Pro (12.9 inch, 3rd generation)",
        "iPad8,7": "iPad Pro (12.9 inch, 3rd generation)",
        "iPad8,8": "iPad Pro (12.9 inch, 3rd generation)",
        "iPad8,9": "iPad Pro (11 inch, 2nd generation)",
        "iPad8,10": "iPad Pro (11 inch, 2nd generation)",
        "iPad8,11": "iPad Pro (12.9 inch, 4th generation)",
        "iPad8,12": "iPad Pro (12.9 inch, 4th generation)",
        "iPad11,1": "iPad mini (5th generation)",
        "iPad11,2": "iPad mini (5th generation)",
        "iPad11,3": "iPad Air (3rd generation)",
        "iPad11,4": "iPad Air (3rd generation)",
        "iPad11,6": "iPad (WiFi)",
        "iPad11,7": "iPad (Cellular)",
        "iPad13,1": "iPad Air (4th generation)",
        "iPad13,2": "iPad Air (4th generation)",
        "iPad13,4": "iPad Pro (11 inch, 3rd generation)",
        "iPad13,5": "iPad Pro (11 inch, 3rd generation)",
        "iPad13,6": "iPad Pro (11 inch, 3rd generation)",
        "iPad13,7": "iPad Pro (11 inch, 3rd generation)",
        "iPad13,8": "iPad Pro (12.9 inch, 5th generation)",
        "iPad13,9": "iPad Pro (12.9 inch, 5th generation)",
        "iPad13,10": "iPad Pro (12.9 inch, 5th generation)",
        "iPad13,11": "iPad Pro (12.9 inch, 5th generation)",
        "iPad14,1": "iPad mini (6th generation)",
        "iPad14,2": "iPad mini (6th generation)",
        "iPad14,3": "iPad Pro 11 inch 4th Gen",
        "iPad14,4": "iPad Pro 11 inch 4th Gen",
        "iPad14,5": "iPad Pro 12.9 inch 6th Gen",
        "iPad14,6": "iPad Pro 12.9 inch 6th Gen",
        "iPad14,8": "iPad Air 6th Gen",
        "iPad14,9": "iPad Air 6th Gen",
        "iPad14,10": "iPad Air 7th Gen",
        "iPad14,11": "iPad Air 7th Gen",
        "iPad16,3": "iPad Pro 11 inch 5th Gen",
        "iPad16,4": "iPad Pro 11 inch 5th Gen",
        "iPad16,5": "iPad Pro 12.9 inch 7th Gen",
        "iPad16,6": "iPad Pro 12.9 inch 7th Gen",
        
        // MARK: - iPod touch
        "iPod1,1": "iPod touch 1",
        "iPod2,1": "iPod touch 2",
        "iPod3,1": "iPod touch 3",
        "iPod4,1": "iPod touch 4",
        "iPod5,1": "iPod touch 5",
        "iPod7,1": "iPod touch 6",
        "iPod9,1": "iPod touch 7",
        
        // MARK: - Simulator
        "i386": "Simulator x86",
        "x86_64": "Simulator x64",
        "arm64": "Simulator arm64",
    ]
    
    /// 灵动岛设备型号列表（iPhone 14 Pro 及后续 Pro 机型）
    public static let dynamicIslandDeviceModels: [String] = [
        "iPhone15,2", "iPhone15,3",  // iPhone 14 Pro / Pro Max
        "iPhone16,1", "iPhone16,2",  // iPhone 15 Pro / Pro Max
        "iPhone17,1", "iPhone17,2",  // iPhone 16 Pro / Pro Max
        "iPhone18,1", "iPhone18,2",  // iPhone 17 Pro / Pro Max
    ]
    
    /// 设备标识符到安全区域内边距的映射（按方向区分）
    public static let safeAreaInsetsDict: [String: [UIInterfaceOrientation: UIEdgeInsets]] = [
        // iPhone 17 Pro / Pro Max
        "iPhone17,1": [
            .portrait: UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 62, bottom: 21, right: 62),
        ],
        "iPhone17,2": [
            .portrait: UIEdgeInsets(top: 62, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 62, bottom: 21, right: 62),
        ],
        // iPhone 16 / 16 Plus / 16e
        "iPhone17,3": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        "iPhone17,4": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        "iPhone17,5": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        // iPhone 15 / 15 Plus
        "iPhone15,4": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        "iPhone15,5": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        // iPhone 15 Pro / Pro Max
        "iPhone16,1": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        "iPhone16,2": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        // iPhone 14 / 14 Plus
        "iPhone14,7": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        "iPhone14,8": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        // iPhone 14 Pro / Pro Max
        "iPhone15,2": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        "iPhone15,3": [
            .portrait: UIEdgeInsets(top: 59, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 59, bottom: 21, right: 59),
        ],
        // iPhone 13 mini
        "iPhone14,4": [
            .portrait: UIEdgeInsets(top: 50, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 50, bottom: 21, right: 50),
        ],
        // iPhone 13
        "iPhone14,5": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        // iPhone 13 Pro / Pro Max
        "iPhone14,2": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        "iPhone14,3": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        // iPhone 12 mini
        "iPhone13,1": [
            .portrait: UIEdgeInsets(top: 50, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 50, bottom: 21, right: 50),
        ],
        // iPhone 12 / 12 Pro / 12 Pro Max
        "iPhone13,2": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        "iPhone13,3": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        "iPhone13,4": [
            .portrait: UIEdgeInsets(top: 47, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 47, bottom: 21, right: 47),
        ],
        // iPhone 11
        "iPhone12,1": [
            .portrait: UIEdgeInsets(top: 48, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 48, bottom: 21, right: 48),
        ],
        // iPhone 11 Pro Max
        "iPhone12,5": [
            .portrait: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0),
            .landscapeLeft: UIEdgeInsets(top: 0, left: 44, bottom: 21, right: 44),
        ],
    ]
    
    /// 6.9 英寸屏幕设备型号（超大屏 iPhone）
    public static let screen69InchModels: [String] = [
        // iPhone 17 Pro Max 等
    ]
    
    /// 6.7 英寸屏幕设备型号（iPhone 14 及后续机型）
    public static let screen67InchAndiPhone14LaterModels: [String] = [
        "iPhone14,8",  // iPhone 14 Plus
        "iPhone15,5",  // iPhone 15 Plus
        "iPhone17,4",  // iPhone 16 Plus
    ]
    
    /// 6.7 英寸屏幕设备型号（iPhone 12 Pro Max、13 Pro Max）
    public static let screen67InchModels: [String] = [
        "iPhone13,4",  // iPhone 12 Pro Max
        "iPhone14,3",  // iPhone 13 Pro Max
    ]
    
    /// 6.5 英寸屏幕设备型号
    public static let screen65InchModels: [String] = [
        "iPhone11,4",  // iPhone XS Max
        "iPhone11,6",  // iPhone XS Max CN
        "iPhone12,5",  // iPhone 11 Pro Max
    ]
    
    /// 6.3 英寸屏幕设备型号
    public static let screen63InchModels: [String] = [
        // 预留
    ]
    
    /// 6.1 英寸屏幕设备型号（iPhone 14 Pro 及后续机型）
    public static let screen61InchAndiPhone14ProLaterModels: [String] = [
        "iPhone15,2",  // iPhone 14 Pro
        "iPhone16,1",  // iPhone 15 Pro
        "iPhone17,1",  // iPhone 16 Pro
        "iPhone18,1",  // iPhone 17 Pro
    ]
    
    /// 6.1 英寸屏幕设备型号（iPhone 12 及后续机型）
    public static let screen61InchAndiPhone12LaterModels: [String] = [
        "iPhone13,2",  // iPhone 12
        "iPhone13,3",  // iPhone 12 Pro
        "iPhone14,5",  // iPhone 13
        "iPhone14,2",  // iPhone 13 Pro
        "iPhone14,7",  // iPhone 14
        "iPhone15,4",  // iPhone 15
        "iPhone17,3",  // iPhone 16
        "iPhone18,3",  // iPhone 17
    ]
    
    /// 6.1 英寸屏幕设备型号（iPhone XR、iPhone 11）
    public static let screen61InchModels: [String] = [
        "iPhone11,8",  // iPhone XR
        "iPhone12,1",  // iPhone 11
    ]
    
    /// 5.8 英寸屏幕设备型号（iPhone X、XS、11 Pro）
    public static let screen58InchModels: [String] = [
        "iPhone10,3",  // iPhone X
        "iPhone10,6",  // iPhone X
        "iPhone11,2",  // iPhone XS
        "iPhone12,3",  // iPhone 11 Pro
    ]
    
    /// 5.5 英寸屏幕设备型号（iPhone 6 Plus 系列）
    public static let screen55InchModels: [String] = [
        "iPhone7,1",   // iPhone 6 Plus
        "iPhone8,2",   // iPhone 6s Plus
        "iPhone9,2",   // iPhone 7 Plus
        "iPhone10,2",  // iPhone 8 Plus
    ]
    
    /// 5.4 英寸屏幕设备型号（iPhone 12 mini、13 mini）
    public static let screen54InchModels: [String] = [
        "iPhone13,1",  // iPhone 12 mini
        "iPhone14,4",  // iPhone 13 mini
    ]
    
    /// 4.7 英寸屏幕设备型号（iPhone 6 系列）
    public static let screen47InchModels: [String] = [
        "iPhone7,2",   // iPhone 6
        "iPhone8,1",   // iPhone 6s
        "iPhone9,1",   // iPhone 7
        "iPhone10,1",  // iPhone 8
    ]
    
    /// 4.0 英寸屏幕设备型号（iPhone 5 系列、SE）
    public static let screen40InchModels: [String] = [
        "iPhone5,1",   // iPhone 5
        "iPhone5,2",   // iPhone 5
        "iPhone5,3",   // iPhone 5c
        "iPhone5,4",   // iPhone 5c
        "iPhone6,1",   // iPhone 5s
        "iPhone6,2",   // iPhone 5s
        "iPhone8,4",   // iPhone SE
        "iPhone12,8",  // iPhone SE (2nd generation)
        "iPhone14,6",  // iPhone SE (3rd generation)
    ]
    
    /// 3.5 英寸屏幕设备型号（iPhone 4 系列）
    public static let screen35InchModels: [String] = [
        "iPhone1,1",   // iPhone 1G
        "iPhone1,2",   // iPhone 3G
        "iPhone2,1",   // iPhone 3GS
        "iPhone3,1",   // iPhone 4
        "iPhone3,2",   // iPhone 4
        "iPhone3,3",   // iPhone 4 (CDMA)
        "iPhone4,1",   // iPhone 4S
    ]
}