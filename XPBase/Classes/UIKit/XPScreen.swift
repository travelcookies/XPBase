import UIKit

/// 屏幕信息工具类（XP命名空间版本）
/// 提供全面的屏幕尺寸、设备类型、安全区域等信息，支持各种iPhone/iPad设备的适配
///
/// 使用示例：
/// ```swift
/// // 获取屏幕尺寸
/// let screenWidth = XPScreen.width
/// let screenHeight = XPScreen.height
///
/// // 获取设备类型信息
/// let deviceModel = XPScreen.deviceModel // 设备型号标识符
/// let deviceName = XPScreen.deviceName   // 设备名称（如 "iPhone 15 Pro"）
///
/// // 判断设备类型
/// let isIPhone = XPScreen.isIPhone
/// let isIPad = XPScreen.isIPad
/// let isSimulator = XPScreen.isSimulator
///
/// // 判断屏幕类型
/// let isNotchedScreen = XPScreen.isNotchedScreen   // 是否有刘海/灵动岛
/// let isDynamicIslandScreen = XPScreen.isDynamicIslandScreen  // 是否灵动岛屏幕
/// let isFullScreen = XPScreen.isFullScreen   // 是否全屏设备
///
/// // 获取安全区域
/// let safeAreaInsets = XPScreen.safeAreaInsets
/// let safeBottom = XPScreen.safeAreaBottom
/// let safeTop = XPScreen.safeAreaTop
///
/// // 获取导航栏和状态栏高度
/// let navBarHeight = XPScreen.navBarHeight
/// let navBarFullHeight = XPScreen.navBarFullHeight
/// let statusBarHeight = XPScreen.statusBarFullHeight
///
/// // 获取TabBar高度
/// let tabBarHeight = XPScreen.tabBarHeight
///
/// // 判断屏幕尺寸类型
/// if XPScreen.is61InchScreen {
///     print("这是6.1英寸屏幕")
/// }
/// ```
public struct XPScreen {
    /// 屏幕边界
    public static let bounds = UIScreen.main.bounds
    /// 屏幕宽度
    public static let width = bounds.size.width
    /// 屏幕高度
    public static let height = bounds.size.height
    /// 原生屏幕边界（物理像素）
    public static let nativeBounds = UIScreen.main.nativeBounds
    /// 原生屏幕宽度（物理像素）
    public static let nativeWidth = nativeBounds.size.width
    /// 原生屏幕高度（物理像素）
    public static let nativeHeight = nativeBounds.size.height
    /// 屏幕缩放因子
    public static let scale = UIScreen.main.scale
    /// 原生屏幕缩放因子
    public static let nativeScale = UIScreen.main.nativeScale
    
    /// 是否为放大模式（Zoomed Mode）
    public static var isZoomedMode: Bool {
        if !isIPhone { return false }
        
        let shouldBeDownsampledDevice = nativeBounds.size == CGSize(width: 1080, height: 1920)
        var currentScale = scale
        if shouldBeDownsampledDevice {
            currentScale /= 1.15
        }
        
        return nativeScale > currentScale
    }
    
    private static var _deviceModel: String?
    /// 设备型号标识符（如 "iPhone16,1"）
    public static var deviceModel: String {
        if let model = _deviceModel {
            return model
        }
        
        if isSimulator {
            if let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                _deviceModel = identifier
                return identifier
            }
        }
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        _deviceModel = identifier
        return identifier
    }
    
    private static var _deviceName: String?
    /// 设备名称（如 "iPhone 15 Pro"）
    public static var deviceName: String {
        if let name = _deviceName {
            return name
        }
        
        let model = deviceModel
        var name = XPDeviceModelConfiguration.deviceNames[model] ?? model
        if isSimulator {
            name += " Simulator"
        }
        
        _deviceName = name
        return name
    }
}

extension XPScreen {
    /// 设备宽度（取宽高中较小值，适配横竖屏）
    public static let deviceWidth = min(width, height)
    /// 设备高度（取宽高中较大值，适配横竖屏）
    public static let deviceHeight = max(width, height)
    
    /// 是否为 iPad
    public static var isIPad: Bool {
        UI_USER_INTERFACE_IDIOM() == .pad
    }
    
    /// 是否为 iPod touch
    public static var isIPod: Bool {
        UIDevice.current.model.contains("iPod touch")
    }
    
    /// 是否为 iPhone
    public static var isIPhone: Bool {
        UIDevice.current.model.contains("iPhone")
    }
    
    /// 是否为模拟器
    public static var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// 是否为 Mac（Mac Catalyst 或 iOS App on Mac）
    public static var isMac: Bool {
        if #available(iOS 14.0, *) {
            return ProcessInfo().isiOSAppOnMac || ProcessInfo().isMacCatalystApp
        }
        if #available(iOS 13.0, *) {
            return ProcessInfo().isMacCatalystApp
        }
        return false
    }
    
    /// 是否为灵动岛屏幕（iPhone 14 Pro 及后续 Pro 机型）
    public static var isDynamicIslandScreen: Bool {
        if !isIPhone { return false }
        
        let excludeModels = ["iPhone 16e"]
        if excludeModels.contains(where: { deviceName.hasPrefix($0) }) {
            return false
        }
        
        let models = ["iPhone 14 Pro", "iPhone 15", "iPhone 16", "iPhone 17", "iPhone Air"]
        return models.contains(where: { deviceName.hasPrefix($0) })
    }
    
    /// 是否为 Liquid Glass 设计（iOS 26+ 新设计语言）
    public static var isLiquidGlass: Bool {
        if #available(iOS 26.0, *) {
            if let infoDict = Bundle.main.infoDictionary,
               let requiresCompatibility = infoDict["UIDesignRequiresCompatibility"] as? Bool {
                return !requiresCompatibility
            }
            return true
        }
        return false
    }
    
    private static var _isNotchedScreen: Bool?
    /// 是否为刘海屏/全屏设备
    public static var isNotchedScreen: Bool {
        if let value = _isNotchedScreen {
            return value
        }
        
        var result = false
        
        if #available(iOS 11.0, *) {
            let insets = safeAreaInsets
            result = insets.bottom > 0
        } else {
            result = is58InchScreen
        }
        
        _isNotchedScreen = result
        return result
    }
    
    /// 是否为常规屏幕尺寸（大屏设备）
    public static var isRegularScreen: Bool {
        if isDynamicIslandScreen {
            return true
        }
        return isIPad || (!isZoomedMode && (is67InchScreenAndiPhone14Later || is67InchScreen || is65InchScreen || is61InchScreen || is55InchScreen))
    }
}

extension XPScreen {
    private static var _is69InchScreen: Bool?
    /// 是否为 6.9 英寸屏幕（超大屏 iPhone）
    public static var is69InchScreen: Bool {
        if let value = _is69InchScreen {
            return value
        }
        _is69InchScreen = deviceWidth == 440 && deviceHeight == 956
        return _is69InchScreen!
    }
    
    private static var _is67InchScreenAndiPhone14Later: Bool?
    /// 是否为 iPhone 14 及后续机型的 6.7 英寸屏幕
    public static var is67InchScreenAndiPhone14Later: Bool {
        if let value = _is67InchScreenAndiPhone14Later {
            return value
        }
        _is67InchScreenAndiPhone14Later = deviceWidth == 430 && deviceHeight == 932
        return _is67InchScreenAndiPhone14Later!
    }
    
    private static var _is67InchScreen: Bool?
    /// 是否为 6.7 英寸屏幕（iPhone 12 Pro Max、13 Pro Max）
    public static var is67InchScreen: Bool {
        if let value = _is67InchScreen {
            return value
        }
        _is67InchScreen = deviceWidth == 428 && deviceHeight == 926
        return _is67InchScreen!
    }
    
    private static var _is65InchScreen: Bool?
    public static var is65InchScreen: Bool {
        if let value = _is65InchScreen {
            return value
        }
        _is65InchScreen = deviceWidth == 414 && deviceHeight == 896 &&
            (deviceModel == "iPhone11,4" || deviceModel == "iPhone11,6" || deviceModel == "iPhone12,5")
        return _is65InchScreen!
    }
    
    private static var _is63InchScreen: Bool?
    public static var is63InchScreen: Bool {
        if let value = _is63InchScreen {
            return value
        }
        _is63InchScreen = deviceWidth == 402 && deviceHeight == 874
        return _is63InchScreen!
    }
    
    private static var _is61InchScreenAndiPhone14ProLater: Bool?
    public static var is61InchScreenAndiPhone14ProLater: Bool {
        if let value = _is61InchScreenAndiPhone14ProLater {
            return value
        }
        _is61InchScreenAndiPhone14ProLater = deviceWidth == 393 && deviceHeight == 852
        return _is61InchScreenAndiPhone14ProLater!
    }
    
    private static var _is61InchScreenAndiPhone12Later: Bool?
    public static var is61InchScreenAndiPhone12Later: Bool {
        if let value = _is61InchScreenAndiPhone12Later {
            return value
        }
        _is61InchScreenAndiPhone12Later = deviceWidth == 390 && deviceHeight == 844
        return _is61InchScreenAndiPhone12Later!
    }
    
    private static var _is61InchScreen: Bool?
    public static var is61InchScreen: Bool {
        if let value = _is61InchScreen {
            return value
        }
        _is61InchScreen = deviceWidth == 414 && deviceHeight == 896 &&
            (deviceModel == "iPhone11,8" || deviceModel == "iPhone12,1")
        return _is61InchScreen!
    }
    
    private static var _is58InchScreen: Bool?
    public static var is58InchScreen: Bool {
        if let value = _is58InchScreen {
            return value
        }
        _is58InchScreen = deviceWidth == 375 && deviceHeight == 812
        return _is58InchScreen!
    }
    
    private static var _is55InchScreen: Bool?
    public static var is55InchScreen: Bool {
        if let value = _is55InchScreen {
            return value
        }
        _is55InchScreen = deviceWidth == 414 && deviceHeight == 736
        return _is55InchScreen!
    }
    
    private static var _is54InchScreen: Bool?
    public static var is54InchScreen: Bool {
        if let value = _is54InchScreen {
            return value
        }
        _is54InchScreen = deviceWidth == 375 && deviceHeight == 812
        return _is54InchScreen!
    }
    
    private static var _is47InchScreen: Bool?
    public static var is47InchScreen: Bool {
        if let value = _is47InchScreen {
            return value
        }
        _is47InchScreen = deviceWidth == 375 && deviceHeight == 667
        return _is47InchScreen!
    }
    
    private static var _is40InchScreen: Bool?
    public static var is40InchScreen: Bool {
        if let value = _is40InchScreen {
            return value
        }
        _is40InchScreen = deviceWidth == 320 && deviceHeight == 568
        return _is40InchScreen!
    }
    
    private static var _is35InchScreen: Bool?
    public static var is35InchScreen: Bool {
        if let value = _is35InchScreen {
            return value
        }
        _is35InchScreen = deviceWidth == 320 && deviceHeight == 480
        return _is35InchScreen!
    }
}

extension XPScreen {
    /// 获取当前关键窗口（私有）
    private static var _keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if let scene = windowScene as? UIWindowScene,
                   scene.activationState == .foregroundActive {
                    for window in scene.windows {
                        if window.isKeyWindow {
                            return window
                        }
                    }
                }
            }
        }
        
        if let window = UIApplication.shared.windows.first {
            if window.isKeyWindow {
                return window
            }
            
            if let keyWindow = UIApplication.shared.keyWindow,
               keyWindow.bounds == UIScreen.main.bounds {
                return keyWindow
            }
        }
        
        return UIApplication.shared.delegate?.window ?? nil
    }
    
    /// 安全区域内边距
    public static var safeAreaInsets: UIEdgeInsets {
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            if let window = _keyWindow {
                insets = window.safeAreaInsets
            } else {
                let window = UIWindow(frame: UIScreen.main.bounds)
                insets = window.safeAreaInsets
                
                if insets.bottom <= 0 {
                    let viewController = UIViewController()
                    window.rootViewController = viewController
                }
            }
        }
        return insets
    }
    
    /// 状态栏框架
    public static var statusBarFrame: CGRect {
        if #available(iOS 13.0, *) {
            for windowScene in UIApplication.shared.connectedScenes {
                if let scene = windowScene as? UIWindowScene {
                    return scene.statusBarManager?.statusBarFrame ?? .zero
                }
            }
        }
        return UIApplication.shared.statusBarFrame
    }
    
    public static var isLandscape: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
        }
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
}

extension XPScreen {
    private static var navBarForIpad: CGFloat {
        isLiquidGlass ? 54 : ((Double(UIDevice.current.systemVersion) ?? 0) >= 12.0 ? 50 : 44)
    }
    
    private static var navBarForIphone: CGFloat {
        isLiquidGlass ? 54 : 44
    }
    
    /// 导航栏高度（不含状态栏）
    public static var navBarHeight: CGFloat {
        if isIPad {
            return navBarForIpad
        }
        if isLandscape {
            return isRegularScreen ? navBarForIphone : 32
        }
        return navBarForIphone
    }
    
    /// 竖屏导航栏高度（不含状态栏）
    public static var navBarHeightForPortrait: CGFloat {
        isIPad ? navBarForIpad : navBarForIphone
    }
    
    /// 非全屏设备导航栏高度（不含状态栏）
    public static var navBarHeightNonFullScreen: CGFloat {
        isLiquidGlass ? 70 : 56
    }
    
    private static var navBarForIphonePortrait: CGFloat {
        let pixelOne = 1.0 / scale
        let insets = safeAreaInsets
        var safeTop = insets.top
        
        if isNotchedScreen {
            safeTop = max(max(insets.left, insets.right), max(insets.top, insets.bottom))
        }
        
        var result = navBarForIphone
        
        if isLiquidGlass {
            result += safeTop
        } else if isDynamicIslandScreen {
            if safeTop <= 59 {
                result += (safeTop - 5 - pixelOne)
            } else {
                result += (safeTop - 5 - 2 * pixelOne)
            }
        } else {
            result += safeTop
        }
        
        return result
    }
    
    /// 导航栏总高度（含状态栏）
    public static var navBarFullHeight: CGFloat {
        let statusBarH = statusBarFullHeight
        var result: CGFloat = 0
        
        if isIPad {
            result += statusBarH
            result += navBarForIpad
        } else if isLandscape {
            if isLiquidGlass {
                result += 24
            } else {
                result += statusBarH
            }
            result += isRegularScreen ? navBarForIphone : 32
        } else {
            result = navBarForIphonePortrait
        }
        
        return result
    }
    
    /// 竖屏导航栏总高度（含状态栏）
    public static var navBarFullHeightForPortrait: CGFloat {
        let statusBarH = statusBarHeightForPortrait
        var result: CGFloat = 0
        
        if isIPad {
            result += statusBarH
            result += navBarForIpad
        } else {
            result = navBarForIphonePortrait
        }
        
        return result
    }
    
    /// 状态栏总高度
    public static var statusBarFullHeight: CGFloat {
        if !UIApplication.shared.isStatusBarHidden {
            return statusBarFrame.height
        }
        
        if isIPad {
            return isNotchedScreen ? 24 : 20
        }
        
        if !isNotchedScreen {
            return 20
        }
        
        if isLandscape {
            return 0
        }
        
        return statusBarHeightForPortrait
    }
    
    /// 竖屏状态栏高度
    public static var statusBarHeightForPortrait: CGFloat {
        if isIPad {
            return isNotchedScreen ? 24 : 20
        }
        
        if !isNotchedScreen {
            return 20
        }
        
        if isDynamicIslandScreen {
            return 54
        }
        
        if is61InchScreenAndiPhone12Later || is67InchScreen {
            return 47
        }
        
        if is61InchScreen {
            if #available(iOS 14.0, *) {
                return 48
            } else {
                return 44
            }
        }
        
        let version = Double(UIDevice.current.systemVersion) ?? 0
        return (is54InchScreen && version >= 15.0) ? 50 : 44
    }
    
    private static var _tabBarHeight: CGFloat?
    /// TabBar高度（含底部安全区域）
    public static var tabBarHeight: CGFloat {
        if let height = _tabBarHeight {
            return height
        }
        
        var height: CGFloat = 49
        
        if isIPad {
            if isNotchedScreen {
                height = 65
            } else {
                height = (Double(UIDevice.current.systemVersion) ?? 0) >= 12.0 ? 50 : 49
            }
        } else {
            if isLandscape {
                height = isRegularScreen ? 49 : 32
            }
            height += safeAreaInsetsForDeviceWithNotch().bottom
        }
        
        _tabBarHeight = height
        return height
    }
    
    /// 获取带刘海/灵动岛设备的安全区域内边距
    public static func safeAreaInsetsForDeviceWithNotch() -> UIEdgeInsets {
        if !isNotchedScreen {
            return .zero
        }
        
        if isIPad {
            return UIEdgeInsets(top: 24, left: 0, bottom: 20, right: 0)
        }
        
        let safeAreaInsetsDict = XPDeviceModelConfiguration.safeAreaInsetsDict
        
        var deviceKey = deviceModel
        if !safeAreaInsetsDict.keys.contains(deviceKey) {
            deviceKey = "iPhone16,1"
        }
        
        if isZoomedMode {
            deviceKey += "-Zoom"
        }
        
        let orientation = UIApplication.shared.statusBarOrientation
        var orientationKey: UIInterfaceOrientation
        
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            orientationKey = .landscapeLeft
        default:
            orientationKey = .portrait
        }
        
        var insets = safeAreaInsetsDict[deviceKey]?[orientationKey] ?? .zero
        
        if orientation == .portraitUpsideDown {
            insets = UIEdgeInsets(top: insets.bottom, left: insets.left, bottom: insets.top, right: insets.right)
        } else if orientation == .landscapeRight {
            insets = UIEdgeInsets(top: insets.top, left: insets.right, bottom: insets.bottom, right: insets.left)
        }
        
        return insets
    }
}

extension XPScreen {
    /// 是否为全屏设备（刘海屏/灵动岛）
    public static var isFullScreen: Bool {
        isNotchedScreen
    }
    
    /// 状态栏高度（别名）
    public static let statusHeight: CGFloat = statusBarFullHeight
    
    /// 导航栏高度（别名，不含状态栏）
    public static let naviBarHeight: CGFloat = navBarHeight
    
    /// 导航栏总高度（别名，含状态栏）
    public static let navigationBarHeight: CGFloat = navBarFullHeight
    
    /// 底部安全区域高度
    public static let safeAreaBottom: CGFloat = safeAreaInsets.bottom
    
    /// 顶部安全区域高度
    public static let safeAreaTop: CGFloat = safeAreaInsets.top
    
    /// 是否为 iPhone 4/4s（屏幕高度 < 568）
    public static let iPhone4 = deviceHeight < 568
    /// 是否为 iPhone 5/5s/SE（屏幕高度 == 568）
    public static let iPhone5 = deviceHeight == 568
    /// 是否为 iPhone 6/6s/7/8（屏幕高度 == 667）
    public static let iPhone6 = deviceHeight == 667
    /// 是否为 iPhone 6 Plus/6s Plus/7 Plus/8 Plus（屏幕高度 == 736）
    public static let iPhone6P = deviceHeight == 736
    /// 是否为 iPhone X/XS/11 Pro（屏幕高度 == 812）
    public static let iPhoneX = deviceHeight == 812
}
