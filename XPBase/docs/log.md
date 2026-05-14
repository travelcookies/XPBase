# Log 模块

## XPLogger

**功能说明**：日志工具类，提供不同级别的日志输出功能，支持日志级别过滤、配置选项和生产环境自动过滤。

### 日志级别

| 级别 | 优先级 | 说明 |
|------|--------|------|
| `.debug` | 0 | 调试信息（生产环境默认关闭） |
| `.info` | 1 | 一般信息 |
| `.default` | 2 | 普通日志 |
| `.error` | 3 | 错误信息 |
| `.fault` | 4 | 严重错误 |

### 配置选项

```swift
// 配置全局日志级别
XPLogger.configuration.globalLogLevel = .info // 只输出 info 及以上级别

// 配置是否在生产环境禁用调试日志
XPLogger.configuration.disableDebugInProduction = true // 默认 true

// 配置是否显示源码位置（文件、函数、行号）
XPLogger.configuration.showSourceLocation = true // 默认 true

// 配置是否显示时间戳
XPLogger.configuration.showTimestamp = true // 默认 true
```

### 使用示例

```swift
// 创建日志器实例
let logger = XPLogger(category: "Network")

// 输出不同级别的日志
logger.debug("请求参数: \(params)")    // 调试级别
logger.info("请求开始")                 // 信息级别
logger.log("普通日志")                  // 默认级别
logger.error("请求失败: \(error)")     // 错误级别
logger.fault("严重错误")               // 严重级别

// 使用便捷方法
XPLogger.debug("全局调试日志")
XPLogger.info("全局信息日志")
XPLogger.error("全局错误日志")

// 检查日志级别是否会被输出（用于昂贵的日志准备操作）
if logger.isLogEnabled(for: .debug) {
    let detailedInfo = prepareDetailedLogInfo()
    logger.debug(detailedInfo)
}
```

### 生产环境自动过滤

当 `disableDebugInProduction = true` 时：
- **Debug 模式**：遵循 `globalLogLevel` 设置
- **Release 模式**：自动将最低日志级别设为 `.info`，`.debug` 级别的日志会被自动过滤

### 日志格式

输出日志格式如下：
```
[2024-01-15 10:30:00] [Network] [DEBUG] request.swift:25 - requestStarted() - 请求开始
```

### 命名空间方法

```swift
// 使用 XP 命名空间
"message".log()           // 默认级别
"message".log(level: .debug)
"message".debug()
"message".info()
"message".error()
```