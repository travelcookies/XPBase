# XPBase API 文档

本文档汇总了 XPBase 框架中所有工具类和扩展的功能说明及使用示例。

---

## 目录

- [UIKit 模块](uikit.md)
  - XPScreen
  - XPDevice
  - XPColor
  - XPFont
  - XPUnderlineButton
  - XPUnderlineTextField
  - XPCountDownButton
  - XPDashedBorderView
  - XPGradientButton
  - XPGradientView
  - XPRootViewControllerManager
  - XPDeviceModelConfiguration
- [Tool 模块](tool.md)
  - XPTimer
  - XPDebounce
  - XPThrottle
  - XPAppInfo
  - XPImage
  - XPAnimation
  - XPTime
  - XPAsync
  - XPLanguageManager
  - XPCounter
  - XPMarqueeView
  - XPFileManager
  - XPCacheManager
  - XPKeyChain
  - XPMediaDownloadManager
- [Extensions 模块](extensions.md)
  - Array+Extension
  - String+Extension
  - Date+Extension
  - UIColor+Extension
  - UIView+Extension
  - Codable+Extension
  - Int+Extension
  - UIAlertController+Extension
  - UIButton+Extension
  - UIImage+Extension
  - UITableView+Extension
  - UITextField+Extension
  - XPCompatible
- [Network 模块](network.md)
  - XPNetworkLoggerPlugin
  - XPBaseModel
  - XPReachableManager
- [Log 模块](log.md)
  - XPLogger
- [Navigator 模块](navigator.md)
  - XPNavigator
- [MediaPicker 模块](media-picker.md)
  - XPMediaPickerTool
- [WebView 模块](webview.md)
  - XPWebPageController
- [Toast 模块](toast.md)
  - XPToast
- [命名空间说明](namespace.md)

---

## 模块概览

| 模块 | 文件数 | 说明 |
|------|--------|------|
| **UIKit** | 10 | 界面组件和工具类 |
| **Tool** | 14 | 工具类集合 |
| **Extensions** | 5 | Swift 扩展 |
| **Network** | 3 | 网络相关工具 |
| **Log** | 1 | 日志工具 |
| **Navigator** | 1 | 路由导航 |
| **MediaPicker** | 1 | 媒体选择 |
| **WebView** | 1 | 网页组件 |
| **Toast** | 1 | 提示组件 |

---

## 快速开始

XPBase 框架提供了丰富的工具类和扩展方法，涵盖了 UIKit、网络请求、日志、导航、媒体处理等多个方面，旨在提高 iOS 开发效率和代码质量。

### 安装

```swift
// 在 Podfile 中添加
pod 'XPBase'

// 或直接集成源码
import XPBase
```

### 核心功能

1. **屏幕适配** - `XPScreen` 提供全面的屏幕信息
2. **颜色处理** - `XPColor` 支持多种颜色创建方式
3. **网络请求** - 基于 Moya 的网络层封装
4. **日志系统** - `XPLogger` 提供多级别日志
5. **路由导航** - `XPNavigator` 提供页面跳转

---

## 更新记录

- **v1.0.0** - 初始版本，包含基础工具类
- **v1.1.0** - 添加网络模块和日志模块
- **v1.2.0** - 添加 UIKit 组件和动画工具
- **v1.3.0** - 完善文档，添加高级用法示例

---

**文档版本**: 1.3.0  
**最后更新**: 2026-05-14
