# XPBase

[![CI Status](https://img.shields.io/travis/roc-mini/XPBase.svg?style=flat)](https://travis-ci.org/roc-mini/XPBase)
[![Version](https://img.shields.io/cocoapods/v/XPBase.svg?style=flat)](https://cocoapods.org/pods/XPBase)
[![License](https://img.shields.io/cocoapods/l/XPBase.svg?style=flat)](https://cocoapods.org/pods/XPBase)
[![Platform](https://img.shields.io/cocoapods/p/XPBase.svg?style=flat)](https://cocoapods.org/pods/XPBase)

XPBase 是一个功能丰富的 iOS 开发基础库，提供了网络请求、日志管理、UI 扩展、工具类等常用功能，旨在简化 iOS 应用开发过程中的重复工作，提高开发效率。

## 🚀 快速开始

### 安装

```ruby
# 在 Podfile 中添加
pod 'XPBase', :git => 'https://github.com/travelcookies/XPBase.git'
```

### 初始化

```swift
import XPBase

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 配置日志级别
    XPLogger.configuration.globalLogLevel = .debug
    
    // 开始监测网络状态
    XPReachableManager.shared.startMonitoring()
    
    return true
}
```

## ✨ 核心功能

### 1. 网络请求

基于 Moya 封装的网络请求模块，支持泛型模型解析和统一错误处理。

```swift
let provider = MoyaProvider<MyAPI>()
provider.request(.getUser, model: UserResponse.self) { data in
    if let user = data?.data {
        print(user.name)
    }
}
```

### 2. 日志管理

支持多级别日志输出，自动区分开发和生产环境。

```swift
let logger = XPLogger(category: "Network")
logger.debug("请求参数")
logger.info("请求开始")
logger.error("请求失败")
```

### 3. UI 扩展

提供丰富的 UI 控件扩展方法。

```swift
// 添加圆角
view.xp.addCorner(radius: 8)

// 添加阴影
view.xp.addShadow(color: .black, offset: CGSize(width: 0, height: 2))

// 颜色转换
let color = UIColor(hex: "#FF5733")
```

### 4. 设备信息

获取设备和应用信息。

```swift
let deviceName = XPDevice.shared.name
let appVersion = XPAppInfo.appVersion
let screenWidth = XPScreen.width
```

### 5. 工具类

提供定时器、防抖、节流、缓存等工具类。

```swift
// 防抖
XPDebounce.shared.execute(id: "search", delay: 0.5) {
    print("执行搜索")
}

// 缓存
let cache = XPCacheManager(name: "MyCache")
cache.addUpdateCache(key: "user", value: userData)
```

## 📦 模块概览

| 模块 | 说明 |
|------|------|
| **UIKit** | 屏幕适配、颜色、字体、自定义控件 |
| **Network** | 网络请求、网络状态监测 |
| **Log** | 日志管理 |
| **Tool** | 定时器、防抖、节流、缓存等工具类 |
| **Extensions** | Swift 类型扩展 |
| **Navigator** | 路由导航 |
| **MediaPicker** | 媒体选择 |
| **Toast** | 提示组件 |

## 📖 完整文档

查看 [API 文档](XPBase/docs/SUMMARY.md) 获取详细的使用说明。

## 🔧 示例项目

```bash
# 运行示例项目
cd Example
pod install
open XPBase.xcworkspace
```

## 📋 技术栈

- **Swift 5.0+**
- **Moya 15.0+** - 网络请求
- **HandyJSON 5.0+** - JSON 解析
- **Toast-Swift 5.0+** - 提示组件
- **Reachability 5.0+** - 网络状态监测
- **SnapKit 5.0+** - 自动布局

## 📝 更新记录

- **v1.2.0** - 添加 UIKit 组件和动画工具
- **v1.1.0** - 添加网络模块和日志模块
- **v1.0.0** - 初始版本，包含基础工具类

## 📄 许可证

XPBase 可在 MIT 许可证下使用。详见 LICENSE 文件。