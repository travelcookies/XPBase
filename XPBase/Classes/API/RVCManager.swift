//
//  SZGetViewController.swift
//  SZParking
//
//  Created by 林小鹏 on 2022/10/18.
//  Copyright © 2022 ningbokubin. All rights reserved.
//

import Foundation
import UIKit
/// 获取当前VC
public class RVCManager {
    /// 获取当前VC
    public class func getCurrentVC() -> UIViewController {
        let windows = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
//        let rootVc = UIApplication.shared.keyWindow?.rootViewController
        let rootVc = windows?.rootViewController
        let currentVc = getCurrentVcFrom(rootVc!)
        return currentVc
    }

    static var currentVC: UIViewController {
        let windows = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        let rootVc = windows?.rootViewController
        let currentVc = RVCManager.getCurrentVcFrom(rootVc!)
        return currentVc
    }

    private class func getCurrentVcFrom(_ rootVc: UIViewController) -> UIViewController {
        var currentVc: UIViewController
        var rootCtr = rootVc
        if rootCtr.presentedViewController != nil {
            rootCtr = rootVc.presentedViewController!
        }
        if rootVc.isKind(of: UITabBarController.classForCoder()) {
            currentVc = getCurrentVcFrom((rootVc as! UITabBarController).selectedViewController!)
        } else if rootVc.isKind(of: UINavigationController.classForCoder()) {
            currentVc = getCurrentVcFrom((rootVc as! UINavigationController).visibleViewController!)
        } else {
            currentVc = rootCtr
        }
        return currentVc
    }

    /// 当前window
    /// - Returns: window
    public class func keyWindow() -> UIWindow {
        if #available(iOS 15.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first ?? UIWindow()
            return keyWindow
        } else {
            let keyWindow = UIApplication.shared.windows.first ?? UIWindow()
            return keyWindow
        }
    }
}
