//
//  MoyaProvider+Extension.swift
//  SZParking
//
//  Created by nbfujx on 2020/8/10.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import Foundation
import HandyJSON
import Moya
import Toast_Swift

public extension MoyaProvider {
    /*
     当有返回值的方法未得到接收和使用时通常会出现"Result of call to "getSome()" is unused"的提示
     虽然不会报错，但是影响美观，加上@discardableResult就可以取消这种警告
     */
    @discardableResult
    func request<T>(_ target: Target,
                    model: T.Type,
                    showLoading: Bool = false,
                    showMsg: Bool = true,
                    responseSuccessCode: String = "1",
                    completion: ((_ returnData: T?) -> Void)?) -> Cancellable? {
        if !networkStatusJudgment() {
            showToastText(text: "请检查您的网络")
            return nil
        }

        if showLoading == true {
            YProgressHub.share.loading()
        }

        return request(target, completion: { result in
            if showLoading == true {
                YProgressHub.share.hidden()
            }
            guard completion != nil else { return }

            switch result {
            case let .success(response):

                let jsonDic: [String: Any]? = try! JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String: Any]

                if jsonDic != nil {
                    print("ResponseSuccessCode", target, jsonDic ?? [:])

                    guard let jsonData = JSONDeserializer<BaseModel<T>>.deserializeFrom(dict: jsonDic) else {
                        showToastText(text: "服务器数据错误")
                        completion!(nil)
                        return
                    }
                    if jsonData.code == responseSuccessCode {
                        let clsString = String(describing: type(of: jsonData))
                        if clsString.contains("CodeMsgModel") {
                            print("==== code msg model =====")
                            if jsonData.data == nil {
                                let m = CodeMsgModel()
                                m.code = Int(jsonData.code ?? "0") ?? -1
                                m.msg = jsonData.msg
                                jsonData.data = (m as! T)
                            }
                        }
                        completion!(jsonData.data)

                    } else if jsonData.code == "401" { /** 发送登录页面通知 */
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationShowLoginName"), object: nil)
                    } else {
                        if showMsg {
                            showToastText(text: jsonData.msg ?? "")
                        }
                        completion!(nil)
                    }
                } else {
                    showToastText(text: "服务器访问失败")
                    completion!(nil)
                }
            case let .failure(error):
                self.showError(error)
                completion!(nil)
                break
            }
        })
    }

    fileprivate func showError(_ error: MoyaError) {
        switch error {
        case let .imageMapping(response):
            print("错误原因：\(error.errorDescription ?? "")")
            print(response)
        case let .jsonMapping(response):
            print("错误原因：\(error.errorDescription ?? "")")
            print(response)
        case let .statusCode(response):
            print("错误原因：\(error.errorDescription ?? "")")
            print(response)
        case let .stringMapping(response):
            print("错误原因：\(error.errorDescription ?? "")")
            print(response)
        case let .underlying(_, response):
            print("错误原因：\(error.errorDescription ?? "")")
            print(error)
            print(response as Any)
        case .requestMapping:
            print("错误原因：\(error.errorDescription ?? "")")
            print("nil")
        case .objectMapping:
            print("错误原因：\(error.errorDescription ?? "")")
            print("nil")
        case .encodableMapping:
            print("错误原因：\(error.errorDescription ?? "")")
            print("nil")
        case .parameterEncoding:
            print("错误原因：\(error.errorDescription ?? "")")
            print("nil")
        }
    }
}
