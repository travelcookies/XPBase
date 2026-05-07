# Log 模块

## XPLogger

**功能说明**：日志工具类，提供不同级别的日志输出功能。

**使用示例**：
```swift
// 调试日志
XPLogger.debug("Debug message")

// 信息日志
XPLogger.info("Info message")

// 警告日志
XPLogger.warning("Warning message")

// 错误日志
XPLogger.error("Error message")

// 自定义日志级别
XPLogger.log(level: .debug, message: "Custom message")

// 设置日志级别
XPLogger.minLogLevel = .warning // 只输出警告及以上级别
```
