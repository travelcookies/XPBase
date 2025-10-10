//
//  BaseModel.swift
//  SZParking
//
//  Created by nbfujx on 2020/8/10.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import HandyJSON
import UIKit

class BaseModel<T>: NSObject, HandyJSON {
    var code: String?
    var errCode: String?
    var time: Int?
    var msg: String?
    var data: T?
    override required init() {}
}

class CodeMsgModel: NSObject, HandyJSON {
    var code: Int = -1
    var msg: String?
    override required init() {}
}

class BaseListModel<T>: HandyJSON {
    var records = [T]()
    var pages: Int = 0
    var current: Int = 0
    var total: Int = 0
    var size: Int = 0

    required init() {}
}


/// 弹框提示
func showToastText(text: String) {
    if text == "" {
        return
    }
    RVCManager.keyWindow().makeToast(text, duration: 2.0, position: .center)
}

/// 当前网络状态判断
func networkStatusJudgment() -> Bool {
    let isUse = ReachableManager.shared.stateUseless
    return !isUse
}
