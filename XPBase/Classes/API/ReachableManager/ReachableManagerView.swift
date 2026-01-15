//
//  ReachableManagerView.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/16.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import UIKit

class ReachableManagerView: UIView {

    class func initView() -> ReachableManagerView {
        // 从正确的bundle中加载xib文件
        let bundle = Bundle(for: self)
        return bundle.loadNibNamed("ReachableManagerView", owner: nil, options: nil)?.first as! ReachableManagerView
    }
}
