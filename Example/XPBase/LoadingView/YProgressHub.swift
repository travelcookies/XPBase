//
//  YProgressHub.swift
//  SZParking
//
//  Created by nbfujx on 2020/10/13.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import SnapKit
import UIKit

class YProgressHub {
    static let share = YProgressHub()
    lazy var hubView: YProgressView = {
        let hubView = YProgressView.initView()
        return hubView
    }()

    public var isDisplayLoading: Bool = false

    func loading() {
        guard let rootVC = UIApplication.shared.delegate else {
            return
        }
        hubView.showProgress()
        rootVC.window??.addSubview(hubView)
        isDisplayLoading = true
        hubView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }

    func hidden() {
        hubView.hidden()
        isDisplayLoading = false
        hubView.removeFromSuperview()
    }
}
