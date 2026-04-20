//
//  Nav.swift
//  SZServce
//
//  Created by 林小鹏 on 2023/8/8.
//

import SafariServices
import URLNavigator

protocol NavigationModulesProtocal {
    // 遵循此协议的各 路由注册器 都要实现路由注册方法
    func initRoute(navigator: Navigator)
}

struct Nav {
    static let share = Navigator()

    // 业务路由注册器都存入此数组，用于后续进行统一注册的初始化工作
    private static let modulesRouteArray: [NavigationModulesProtocal] = [HomeRouter()]

    // 注册所有需要用到的业务路由
    static func initBusiness() {
        share.register("http://<path:_>", webViewControllerFactory)
        share.register("https://<path:_>", webViewControllerFactory)

        // 这里初始化所有的模块的路由注册
        for router in modulesRouteArray {
            router.initRoute(navigator: share)
        }
    }

    // 这里是复用了原始demo中的模块，就是当路由是web链接时，用webview打开
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else {
            return nil
        }
        return SFSafariViewController(url: url)
    }
}
