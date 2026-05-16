# Network 模块

## XPNetworkLoggerPlugin

**功能说明**：网络请求日志插件，用于格式化打印 Moya 请求和响应的详细信息。

**使用示例**：
```swift
// 使用默认配置
let loggerPlugin = NetworkLoggerPlugin()
let provider = MoyaProvider<MyAPI>(plugins: [loggerPlugin])

// 使用自定义配置
var config = NetworkLoggerConfig()
config.logHeaders = true
config.logHandler = { message in
    // 自定义日志输出，如写入文件或发送到服务器
    print("Custom Log: \(message)")
}
let customLogger = NetworkLoggerPlugin(config: config)
```

---

## XPBaseModel

**功能说明**：基础响应模型，封装了通用的网络响应数据结构。

**使用示例**：
```swift
// 定义API响应模型
struct UserResponse: XPBaseModel {
    var code: Int
    var message: String
    var data: User?
}

// 使用示例
provider.request(.getUser) { result in
    switch result {
    case .success(let response):
        if let userResponse = try? response.map(UserResponse.self) {
            if userResponse.isSuccess {
                print(userResponse.data)
            } else {
                print(userResponse.message)
            }
        }
    case .failure(let error):
        print(error)
    }
}
```

---

## XPReachableManager

**功能说明**：网络可达性管理器，用于监听网络状态变化。

**使用示例**：
```swift
// 开始监听网络状态
XPReachableManager.shared.startMonitoring()

// 获取当前网络状态
let status = XPReachableManager.shared.networkStatus

// 判断是否有网络
let isReachable = XPReachableManager.shared.isReachable

// 判断是否是WiFi
let isWiFi = XPReachableManager.shared.isWiFi

// 添加网络状态变化监听
XPReachableManager.shared.addListener { status in
    switch status {
    case .reachable(.wifi):
        print("WiFi连接")
    case .reachable(.cellular):
        print("蜂窝网络连接")
    case .unreachable:
        print("无网络连接")
    }
}
```

---

## XPReachableManagerView

**功能说明**：网络不可用提示视图，通过 XIB 文件创建的视图，用于在网络不可用时显示提示信息。

**使用示例**：
```swift
// 创建并显示网络不可用提示视图
let reachableView = XPReachableManagerView.initView()
UIApplication.shared.keyWindow?.addSubview(reachableView)

// 配合 XPReachableManager 使用（通常由管理器自动管理）
// XPReachableManager.shared.startMonitoring()
// 当网络不可用时，管理器会自动创建并显示此视图
```

**主要方法**：

| 方法 | 说明 |
|------|------|
| `initView()` | 创建网络不可用提示视图实例，从 XIB 文件加载 |
