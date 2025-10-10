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
        return Bundle.main.loadNibNamed("ReachableManagerView", owner: nil, options: nil)?.first as! ReachableManagerView
    }
}
