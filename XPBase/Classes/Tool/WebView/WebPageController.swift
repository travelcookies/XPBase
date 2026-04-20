//
//  WebPageController.swift
//  SZParking
//
//  Created by nbfujx on 2020/9/8.
//  Copyright © 2020 ningbokubin. All rights reserved.
//

import GKNavigationBar
import UIKit
import WebKit
/**
 // 创建 WebPageController 实例
 let webVC = WebPageController()
 webVC.urlString = "https://www.example.com"
 webVC.navText = "网页标题"
 webVC.navBackEmpty = false // 是否透明导航栏
 webVC.isAdjustTop = false // 是否调整顶部内容缩进
 webVC.style = .normal // 控制器样式

 // 推送控制器
 navigationController?.pushViewController(webVC, animated: true)
 */
/// Web页面控制器样式枚举
enum WebPageControllerStyle {
    /// 普通
    case normal
}

/// Web页面控制器，用于加载和显示网页
class WebPageController: UIViewController {
    /// 网页URL字符串
    var urlString: String?
    /// 导航栏标题
    var navText: String = ""
    /// 导航栏是否透明
    var navBackEmpty: Bool = false
    /// 是否调整顶部内容缩进
    var isAdjustTop: Bool = false
    /// 控制器样式
    var style: WebPageControllerStyle = .normal
    /// JavaScript交互名称
    let webUserContentControllerName = "sendSuccess"
    /// JavaScript交互名称列表
    private let scriptMessageHandlerNames = ["sendSuccess", "goodsDetailAction", "goodsCategoryAction", "getToken"]

    /// WebView实例
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences.minimumFontSize = 0.0
        config.preferences.javaScriptEnabled = true
        
        let screenWidth = UIScreen.main.bounds.width
        let frameRect: CGRect = CGRect(x: 0, y: rScreen.navigationBarHeight, width: screenWidth, height: rScreen.height - rScreen.navigationBarHeight)
        let webView = WKWebView(frame: frameRect, configuration: config)
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rScreen.safeAreaBottom, right: 0)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        return webView
    }()

    /// 进度条
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.trackTintColor = .clear
        progress.progressTintColor = UIColor.orange
        let screenWidth = UIScreen.main.bounds.width
        progress.frame = CGRect(x: 0, y: rScreen.navigationBarHeight, width: screenWidth, height: 2)
        let transform = CGAffineTransform(scaleX: 1.0, y: 0.5)
        progress.transform = transform
        return progress
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetProgressView()
        addScriptMessageHandlers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        createUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeScriptMessageHandlers()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "estimatedProgress" else { return }
        updateProgressView()
        updateNavigationTitle()
    }
    
    /// 设置导航栏
    private func setupNavigationBar() {
        gk_navigationBar.isHidden = false
        gk_navTitle = navText
        if navBackEmpty {
            gk_backImage = UIImage(named: "nav_icon_back") ?? UIImage()
            gk_navBarAlpha = 0
        }
    }
    
    /// 创建UI
    private func createUI() {
        view.addSubview(webView)
        view.addSubview(progressView)
        loadWebPage()
    }

    deinit {
        webView.uiDelegate = nil
        webView.navigationDelegate = nil
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

// MARK: - 私有方法
extension WebPageController {
    /// 重置进度条
    private func resetProgressView() {
        progressView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.progressView.progress = 0.0
            self.progressView.alpha = 1.0
        }
    }

    /// 更新进度条
    private func updateProgressView() {
        progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        if webView.estimatedProgress >= 1.0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseOut, animations: {
                self.progressView.alpha = 0
            }, completion: { _ in
                self.progressView.setProgress(0.0, animated: false)
                self.progressView.isHidden = true
            })
        }
    }

    /// 更新导航栏标题
    private func updateNavigationTitle() {
        if navText.isEmpty, let title = webView.title, !title.isEmpty {
            gk_navTitle = title
        }
    }

    /// 加载网页
    private func loadWebPage() {
        guard let urlString = urlString, !urlString.isEmpty else {
            showToastText(text: "无效的URL")
            return
        }
        
        // 对URL进行编码，确保特殊字符能正确处理
        if let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedUrlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15.0)
            webView.load(request)
        } else if let url = URL(string: urlString) {
            let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 15.0)
            webView.load(request)
        } else {
            showToastText(text: "无效的URL")
        }
    }

    /// 添加JavaScript消息处理器
    private func addScriptMessageHandlers() {
        scriptMessageHandlerNames.forEach { name in
            webView.configuration.userContentController.add(self, name: name)
        }
    }

    /// 移除JavaScript消息处理器
    private func removeScriptMessageHandlers() {
        scriptMessageHandlerNames.forEach { name in
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
    }
}

// MARK: - WKScriptMessageHandler
extension WebPageController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("JavaScript消息: message.name), 内容: message.body)")
        handleScriptMessage(message)
    }
    
    /// 处理JavaScript消息
    private func handleScriptMessage(_ message: WKScriptMessage) {
        switch message.name {
        case webUserContentControllerName:
            // 处理成功消息，返回上一页
            navigationController?.popViewController(animated: true)
            
        case "goodsDetailAction":
            // 处理商品详情跳转
            if let goodsId = message.body as? String {
                handleGoodsDetailAction(goodsId: goodsId)
            }
            
        case "goodsCategoryAction":
            // 处理商品分类跳转
            if let categoryPath = message.body as? String {
                handleGoodsCategoryAction(categoryPath: categoryPath)
            }
            
        case "getToken":
            // 处理获取Token
            handleGetToken()
            
        default:
            print("未处理的JavaScript消息: message.name)")
        }
    }
    
    /// 处理商品详情跳转
    private func handleGoodsDetailAction(goodsId: String) {
        // 这里可以根据实际需求实现商品详情页面的跳转
        print("跳转到商品详情页面，商品ID: goodsId)")
        // 示例代码：
        // let vc = SZStoresProductDetailsController()
        // vc.hidesBottomBarWhenPushed = true
        // vc.viewModel.goodId = goodsId
        // navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 处理商品分类跳转
    private func handleGoodsCategoryAction(categoryPath: String) {
        // 这里可以根据实际需求实现商品分类页面的跳转
        print("跳转到商品分类页面，分类路径: categoryPath)")
        // 示例代码：
        // Nav.share.push(StoreUrlRouter.storesList.rawValue + "?path=\(categoryPath)&style=specific")
    }
    
    /// 处理获取Token
    private func handleGetToken() {
        // 这里可以根据实际需求实现获取Token并返回给JavaScript
        print("获取Token")
        // 示例代码：
        // let userInfo: UserModel? = UserInfoManager.shared.userInfoGet()
        // guard let token = userInfo?.token, !token.isEmpty else {
        //     return
        // }
        // let inputJS = "getToken('\(token)')"
        // webView.evaluateJavaScript(inputJS) { response, error in
        //     print("返回Token结果: response ?? "无"), 错误: error?.localizedDescription ?? "无")")
        // }
    }
}

// MARK: - WKNavigationDelegate
extension WebPageController: WKNavigationDelegate {
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        resetProgressView()
    }

    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    }

    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 获取网页标题
        if navText.isEmpty {
            getWebPageTitle()
        }
        
        // 隐藏进度条
        UIView.animate(withDuration: 0.3) {
            self.progressView.progress = 1.0
            self.progressView.alpha = 0
        } completion: { _ in
            self.progressView.isHidden = true
            self.progressView.setProgress(0.0, animated: false)
        }
    }

    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // 隐藏进度条
        UIView.animate(withDuration: 0.3) {
            self.progressView.progress = 0.0
            self.progressView.alpha = 0
        } completion: { _ in
            self.progressView.isHidden = true
        }
        
        // 显示错误提示
        showToastText(text: "加载失败: \(error.localizedDescription)")
    }

    // 在加载新的页面时，决定是否允许加载
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // 判断是否是要打开新窗口的请求
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request) // 在当前 WebView 中加载
        }

        decisionHandler(.allow)
    }

    /// 获取网页标题
    private func getWebPageTitle() {
        let titleJs = "document.title"
        webView.evaluateJavaScript(titleJs) { [weak self] result, error in
            guard let self = self, error == nil else {
                return
            }
            
            if let title = result as? String, !title.isEmpty {
                self.gk_navTitle = title
            }
        }
    }
}
