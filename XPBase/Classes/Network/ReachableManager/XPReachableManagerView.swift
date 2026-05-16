//
//  XPReachableManagerView.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/16.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import UIKit

/// 网络不可用提示视图（XP命名空间版本）
/// 通过XIB文件创建的视图，用于在网络不可用时显示提示
///
/// 使用示例：
/// ```swift
/// // 创建并显示网络不可用提示视图
/// let reachableView = XPReachableManagerView.initView()
/// UIApplication.shared.keyWindow?.addSubview(reachableView)
///
/// // 配合 XPReachableManager 使用（通常由管理器自动管理）
/// // XPReachableManager.shared.checkNetworkState()
/// // 当网络不可用时，管理器会自动创建并显示此视图
/// ```
public class XPReachableManagerView: UIView {

    /// 创建网络不可用提示视图实例
    /// - Returns: 从XIB加载的视图实例
    public class func initView() -> XPReachableManagerView {
        let bundle = Bundle(for: self)
        guard let view = bundle.loadNibNamed("XPReachableManagerView", owner: nil, options: nil)?.first as? XPReachableManagerView else {
            fatalError("Unable to load nib named 'XPReachableManagerView'")
        }
        return view
    }
}
