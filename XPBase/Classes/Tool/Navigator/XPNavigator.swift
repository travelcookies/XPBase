//
//  XPNavigator.swift
//  SZServce
//
//  Created by 林小鹏 on 2023/8/8.
//

import SafariServices
import URLNavigator

/// 路由注册协议
/// 遵循此协议的类需要实现路由注册方法，用于注册业务模块的路由
public protocol NavigationModulesProtocal {
    /// 注册路由
    /// - Parameter navigator: URLNavigator 实例
    func initRoute(navigator: Navigator)
}

/// 路由管理工具类（XP命名空间版本）
/// 基于 URLNavigator 封装，提供统一的路由管理和跳转能力
///
/// 使用示例：
/// ```swift
/// // 1. 在 AppDelegate 或 SceneDelegate 中初始化路由
/// XPNavigator.initBusiness()
///
/// // 2. 定义自定义路由注册器
/// class MyRouter: NavigationModulesProtocal {
///     func initRoute(navigator: Navigator) {
///         // 注册路由
///         navigator.register("xp://push/MyViewController") { _, _, _ in
///             return MyViewController()
///         }
///         
///         // 注册带参数的路由
///         navigator.register("xp://push/DetailViewController/<id>") { url, values, context in
///             let vc = DetailViewController()
///             vc.itemId = values["id"] as? String
///             return vc
///         }
///     }
/// }
///
/// // 3. 添加路由注册器
/// XPNavigator.addRouter(MyRouter())
///
/// // 4. 批量添加路由注册器
/// let routers = [HomeRouter(), UserRouter(), OrderRouter()]
/// XPNavigator.addRouters(routers)
///
/// // 5. 执行路由跳转
/// XPNavigator.share.open("xp://push/MyViewController")
///
/// // 6. 带参数跳转
/// XPNavigator.share.open("xp://push/DetailViewController/123")
///
/// // 7. 打开网页链接（自动使用 SFSafariViewController）
/// XPNavigator.share.open("https://www.example.com")
///
/// // 8. 清空所有路由
/// XPNavigator.clearRouters()
///
/// // 9. 重置为默认路由
/// XPNavigator.resetToDefaultRouters()
/// ```
public struct XPNavigator {
    /// 全局共享的 Navigator 实例
    public static let share = Navigator()

    /// 业务路由注册器数组，存储所有需要注册的路由模块
    public static var modulesRouteArray: [NavigationModulesProtocal] = []

    /// 初始化所有业务路由
    /// 注册默认的 HTTP/HTTPS 路由，并初始化所有业务模块的路由
    public static func initBusiness() {
        // 注册 HTTP/HTTPS 链接路由，自动使用 SFSafariViewController 打开
        share.register("http://<path:_>", webViewControllerFactory)
        share.register("https://<path:_>", webViewControllerFactory)

        // 初始化所有业务模块的路由
        for router in modulesRouteArray {
            router.initRoute(navigator: share)
        }
    }

    /// 添加单个路由注册器
    /// - Parameter router: 遵循 NavigationModulesProtocal 的路由注册器
    public static func addRouter(_ router: NavigationModulesProtocal) {
        modulesRouteArray.append(router)
    }

    /// 批量添加路由注册器
    /// - Parameter routers: 路由注册器数组
    public static func addRouters(_ routers: [NavigationModulesProtocal]) {
        modulesRouteArray.append(contentsOf: routers)
    }

    /// 清空所有路由注册器
    public static func clearRouters() {
        modulesRouteArray.removeAll()
    }

    /// 重置为默认路由注册器（清空所有）
    public static func resetToDefaultRouters() {
        modulesRouteArray = []
    }

    /// Web 视图控制器工厂方法
    /// 将 HTTP/HTTPS 链接转换为 SFSafariViewController
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else {
            return nil
        }
        return SFSafariViewController(url: url)
    }
}
