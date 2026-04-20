//
//  Nav.swift
//  SZServce
//
//  Created by 林小鹏 on 2023/8/8.
//

import SafariServices
import URLNavigator

public protocol NavigationModulesProtocal {
    // 遵循此协议的各 路由注册器 都要实现路由注册方法
    func initRoute(navigator: Navigator)
}

public struct Nav {
    public static let share = Navigator()

    // 业务路由注册器都存入此数组，用于后续进行统一注册的初始化工作
    public static var modulesRouteArray: [NavigationModulesProtocal] = []

    // 注册所有需要用到的业务路由
    static func initBusiness() {
        share.register("http://<path:_>", webViewControllerFactory)
        share.register("https://<path:_>", webViewControllerFactory)

        // 这里初始化所有的模块的路由注册
        for router in modulesRouteArray {
            router.initRoute(navigator: share)
        }
    }
    
    // 添加新的路由注册器
    public static func addRouter(_ router: NavigationModulesProtocal) {
        modulesRouteArray.append(router)
    }
    
    // 批量添加路由注册器
    public static func addRouters(_ routers: [NavigationModulesProtocal]) {
        modulesRouteArray.append(contentsOf: routers)
    }
    
    // 清空所有路由注册器
    public static func clearRouters() {
        modulesRouteArray.removeAll()
    }
    
    // 重置为默认路由注册器
    public static func resetToDefaultRouters() {
        modulesRouteArray = []
    }
    
    // 这里是复用了原始demo中的模块，就是当路由是web链接时，用webview打开
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else {
            return nil
        }
        return SFSafariViewController(url: url)
    }
}

// MARK: - 使用方法

/*
使用示例：

// 1. 初始化路由
Nav.initBusiness()

// 2. 添加自定义路由注册器
class MyRouter: NavigationModulesProtocal {
    func initRoute(navigator: Navigator) {
        // 注册路由
        navigator.register("xp://push/MyViewController") { _, _, _ in
            return MyViewController()
        }
    }
}

// 添加路由注册器
Nav.addRouter(MyRouter())

// 3. 批量添加路由注册器
let routers = [Router1(), Router2(), Router3()]
Nav.addRouters(routers)

// 4. 清空路由注册器
Nav.clearRouters()

// 5. 重置为默认路由注册器
Nav.resetToDefaultRouters()

// 6. 直接修改路由注册器数组
Nav.modulesRouteArray = [CustomRouter()]

// 7. 执行路由跳转
Nav.share.open("xp://push/MyViewController")

// 8. 打开网页链接
Nav.share.open("https://www.example.com")
*/

// MARK: - 路由枚举示例（从 HomeRouter.swift 迁移）

/*
enum HomeUrlRoute: String {
    /// 我的页面
    case user = "xp://push/DCCUserController"
    /// 选择货币类型
    case selectCurrency = "xp://push/DCCSelectCurrencyController"
    /// 货币转换
    case currencyConversion = "xp://push/DCCCurrencyConversionController"
    /// 提现
    case withdraw = "xp://push/DCCWithdrawController"
    /// 选择收款人
    case selectPayee = "xp://push/DCCSelectPayeeController"
    /// 添加收款人
    case addPayee = "xp://push/DCCAddPayeeController"
    /// 充值
    case topUp = "xp://push/DCCTopUpController"
}

class HomeRouter: NavigationModulesProtocal {
    func initRoute(navigator: Navigator) {
        navigator.register(HomeUrlRoute.user.rawValue) { _, _, _ in
            let vc = DCCUserController()
            vc.hidesBottomBarWhenPushed = true
            return vc
        }
        
        // 注册其他路由...
    }
}
*/
