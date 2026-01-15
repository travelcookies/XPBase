//
//  BaseModel.swift
//  SZParking
//
//  Created by nbfujx on 2020/8/10.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import HandyJSON
import UIKit

public class BaseModel<T>: NSObject, HandyJSON {
    public var code: String?
    public var errCode: String?
    public var time: Int?
    public var msg: String?
    public var data: T?
    public override required init() {}
}

public class CodeMsgModel: NSObject, HandyJSON {
    public var code: Int = -1
    public var msg: String?
    public override required init() {}
}

public class BaseListModel<T>: HandyJSON {
    public var records = [T]()
    public var pages: Int = 0
    public var current: Int = 0
    public var total: Int = 0
    public var size: Int = 0

    required public init() {}
}


/// 弹框提示
public func showToastText(text: String) {
    if text == "" {
        return
    }
    RVCManager.keyWindow()?.makeToast(text, duration: 2.0, position: .center)
}

/// 当前网络状态判断
public func networkStatusJudgment() -> Bool {
    let isUse = ReachableManager.shared.stateUseless
    return !isUse
}
