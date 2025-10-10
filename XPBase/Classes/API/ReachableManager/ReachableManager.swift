//
//  ReachableManager.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/16.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import Foundation
import Reachability

class ReachableManager {

    var reachableManagerView:ReachableManagerView?
    var isShow:Bool = false

    /// 不可用(默认为可用)
    var stateUseless: Bool = false {
        didSet {
            if stateUseless == true {
                if isShow == true {
                    return
                }
                reachableManagerView = ReachableManagerView.initView()
                UIApplication.shared.keyWindow?.addSubview(reachableManagerView!)
                reachableManagerView!.snp.makeConstraints { (make) in
                    make.top.equalTo(-100)
                    make.left.right.equalTo(0)
                    make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                }

                UIView.animate(withDuration: 0.3) {
                    self.reachableManagerView!.snp.remakeConstraints { (make) in
                        make.left.right.top.equalTo(0)
                        make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                    }
                    self.reachableManagerView?.superview!.layoutIfNeeded()
                }
                isShow = true
            } else {
                if isShow == false {
                    return
                }
                if reachableManagerView != nil {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.reachableManagerView!.snp.makeConstraints { (make) in
                            make.top.equalTo(-100)
                            make.left.right.equalTo(0)
                            make.height.equalTo(rScreen.isFullScreen == true ? 54 : 34)
                        }
                        self.reachableManagerView?.superview!.layoutIfNeeded()
                    }) { (_) in
                        self.reachableManagerView!.removeFromSuperview()
                    }
                }
                isShow = false
            }
        }
    }

    static let shared = ReachableManager()
    fileprivate var reachability: Reachability?

    func checkNetworkState() {
        guard let reachability = try? Reachability() else { return }
        self.reachability = reachability

        reachability.whenReachable = { reach in
            switch reach.connection {
            case .wifi:
                print("Reachable via WiFi")
                self.stateUseless = false
            case .cellular:
                print("Reachable via Cellular")
                self.stateUseless = false
            case .unavailable:
                fallthrough
            default:
                print("Network not reachable")
                self.stateUseless = true
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.stateUseless = true
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    deinit {
        print("reachability.stopNotifier()")
        reachability?.stopNotifier()
    }
}
