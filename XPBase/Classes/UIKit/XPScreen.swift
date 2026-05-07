import UIKit

public enum XPDeviceType: String {
    case iPhone4
    case iPhone5
    case iPhone6
    case iPhone6P
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13Mini
    case iPhone13
    case iPhone13Pro
    case iPhone13ProMax
    case iPhone14
    case iPhone14Plus
    case iPhone14Pro
    case iPhone14ProMax
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax
    case iPhone16
    case iPhone16Plus
    case iPhone16Pro
    case iPhone16ProMax
    case iPhone17
    case iPhone17Plus
    case iPhone17Pro
    case iPhone17ProMax
    case other
}

public struct XPScreen {
    public static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }

    public static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }

    public static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }

    public static var navigationBarHeight: CGFloat {
        return 44.0
    }

    public static var statusGKHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }

    public static var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            return window?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }

    public static var tabBarHeight: CGFloat {
        return 49.0 + safeAreaBottom
    }

    public static var isFullScreen: Bool {
        return safeAreaBottom > 0 || statusBarHeight > 20
    }

    public static var deviceType: XPDeviceType {
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight == 480 {
            return .iPhone4
        } else if screenHeight == 568 {
            return .iPhone5
        } else if screenHeight == 667 {
            return .iPhone6
        } else if screenHeight == 736 {
            return .iPhone6P
        } else if screenHeight == 812 {
            return .iPhoneX
        } else if screenHeight == 844 {
            return .iPhone12
        } else if screenHeight == 852 {
            return .iPhone14Pro
        } else if screenHeight == 896 {
            return .iPhone11
        } else if screenHeight == 926 {
            return .iPhone12ProMax
        } else if screenHeight == 932 {
            return .iPhone14ProMax
        } else {
            return .other
        }
    }
}

public let rScreen = XPScreen.self