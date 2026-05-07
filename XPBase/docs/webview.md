# WebView 模块

## XPWebPageController

**功能说明**：网页控制器，封装了 WKWebView 的常用功能。

**使用示例**：
```swift
// 创建网页控制器
let webController = XPWebPageController()
webController.urlString = "https://www.example.com"
navigationController?.pushViewController(webController, animated: true)

// 加载本地HTML文件
webController.loadLocalHTML("index.html")

// 加载HTML字符串
webController.loadHTMLString("<html><body>Hello</body></html>")

// 注入JavaScript
webController.evaluateJavaScript("document.title") { result, error in
    if let title = result as? String {
        print(title)
    }
}

// 监听网页加载进度
webController.progressHandler = { progress in
    progressView.progress = progress
}
```
