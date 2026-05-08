import Foundation
import os.log

/// 日志级别枚举
/// 用于区分不同重要程度的日志，便于过滤和查看
public enum LogLevel: String, CaseIterable {
    /// 调试级别，用于详细的调试信息
    case debug
    /// 信息级别，用于一般信息输出
    case info
    /// 默认级别，用于普通日志
    case `default`
    /// 错误级别，用于错误信息
    case error
    /// 严重级别，用于严重错误
    case fault

    /// 日志级别的优先级数值（数值越大优先级越高）
    fileprivate var priority: Int {
        switch self {
        case .debug: return 0
        case .info: return 1
        case .default: return 2
        case .error: return 3
        case .fault: return 4
        }
    }

    /// 对应的图标，用于在print输出时增强可读性
    fileprivate var icon: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .default: return "💬"
        case .error: return "❌"
        case .fault: return "🚨"
        }
    }
}

/// 日志配置结构体
/// 用于配置日志输出行为，支持全局和分类级别设置
public struct XPLoggerConfiguration {
    /// 全局日志级别阈值，低于此级别的日志将被过滤
    public var globalLogLevel: LogLevel = .debug
    /// 是否在生产环境中自动禁用调试日志
    public var disableDebugInProduction: Bool = true
    /// 是否输出文件、函数和行号信息
    public var showSourceLocation: Bool = true
    /// 是否输出时间戳
    public var showTimestamp: Bool = true

    public init() {}
}

/// 统一日志封装，兼容 iOS 9 及以上所有版本
/// 根据系统版本自动选择合适的日志输出方式：iOS 10+ 使用 OSLog，iOS 9 使用 print
///
/// 使用示例：
/// ```swift
/// // 配置全局日志级别（建议在 AppDelegate 中设置）
/// XPLogger.configuration.globalLogLevel = .info // 只输出 info 及以上级别
/// XPLogger.configuration.showSourceLocation = false // 不显示源码位置
///
/// // 创建日志器实例（推荐按模块分类）
/// let networkLogger = XPLogger(category: "Network")
/// let uiLogger = XPLogger(category: "UI")
/// let dataLogger = XPLogger(category: "Data")
///
/// // 输出不同级别的日志
/// networkLogger.log("请求开始", level: .info)
/// networkLogger.debug("请求参数: \(params)")
/// uiLogger.info("视图加载完成")
/// dataLogger.error("数据解析失败")
/// dataLogger.fault("严重错误")
///
/// // 使用默认级别
/// networkLogger.log("普通日志消息")
///
/// // 自定义子系统
/// let customLogger = XPLogger(subsystem: "com.example.app.feature", category: "Feature")
/// customLogger.log("功能模块日志")
///
/// // 检查当前日志级别是否会被输出
/// if networkLogger.isLogEnabled(for: .debug) {
///     // 执行一些昂贵的日志准备操作
///     let detailedInfo = prepareDetailedLogInfo()
///     networkLogger.debug(detailedInfo)
/// }
/// ```
public struct XPLogger {
    private let subsystem: String
    private let category: String
    private let useOSLog: Bool

    /// 默认子系统标识，使用应用的 Bundle ID
    public static var defaultSubsystem: String = {
        Bundle.main.bundleIdentifier ?? "com.yourapp.unknown"
    }()

    /// 全局日志配置
    public static var configuration = XPLoggerConfiguration()

    /// 检查是否为生产环境
    private static var isProduction: Bool {
        #if DEBUG
        return false
        #else
        return true
        #endif
    }

    /// 计算当前有效的全局日志级别
    private static var effectiveGlobalLogLevel: LogLevel {
        if configuration.disableDebugInProduction && isProduction {
            return .info
        }
        return configuration.globalLogLevel
    }

    /// 初始化日志器
    /// - Parameters:
    ///   - subsystem: 子系统标识，通常使用 Bundle ID，默认使用应用的 Bundle ID
    ///   - category: 日志分类，用于区分不同模块，如 "Network"、"UI"、"Database"
    public init(subsystem: String = XPLogger.defaultSubsystem, category: String) {
        self.subsystem = subsystem
        self.category = category

        if #available(iOS 10.0, *) {
            self.useOSLog = true
        } else {
            useOSLog = false
        }
    }

    /// 检查指定级别的日志是否会被输出
    /// - Parameter level: 要检查的日志级别
    /// - Returns: 如果该级别日志会被输出则返回 true，否则返回 false
    public func isLogEnabled(for level: LogLevel) -> Bool {
        return level.priority >= XPLogger.effectiveGlobalLogLevel.priority
    }

    // MARK: - 公共日志方法

    public func log(_ message: String, level: LogLevel = .default, file: String = #file, function: String = #function, line: Int = #line) {
        guard isLogEnabled(for: level) else {
            return
        }

        if useOSLog {
            osLog(message, level: level)
        } else {
            fallbackPrint(message, level: level, file: file, function: function, line: line)
        }
    }

    // MARK: - 便捷日志方法

    /// 输出调试级别日志
    public func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    /// 输出信息级别日志
    public func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    /// 输出默认级别日志
    public func `default`(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .default, file: file, function: function, line: line)
    }

    /// 输出错误级别日志
    public func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }

    /// 输出严重级别日志
    public func fault(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .fault, file: file, function: function, line: line)
    }

    // MARK: - OSLog 实现 (iOS 10+)

    @available(iOS 10.0, *)
    private func osLog(_ message: String, level: LogLevel) {
        let log: OSLog
        let osLogType: OSLogType

        switch level {
        case .debug:
            log = OSLog(subsystem: subsystem, category: category)
            osLogType = .debug
        case .info:
            log = OSLog(subsystem: subsystem, category: category)
            osLogType = .info
        case .error:
            log = OSLog(subsystem: subsystem, category: category)
            osLogType = .error
        case .fault:
            log = OSLog(subsystem: subsystem, category: category)
            osLogType = .fault
        default:
            log = OSLog(subsystem: subsystem, category: category)
            osLogType = .default
        }
        os_log("%{public}@", log: log, type: osLogType, message)
    }

    // MARK: - 降级实现 (iOS 9)

    private func fallbackPrint(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        var formattedParts: [String] = []

        if XPLogger.configuration.showTimestamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss.SSS"
            formattedParts.append(dateFormatter.string(from: Date()))
        }

        formattedParts.append(level.icon)
        formattedParts.append("[\(subsystem)]")
        formattedParts.append("[\(category)]")
        formattedParts.append(message)

        if XPLogger.configuration.showSourceLocation {
            let fileName = (file as NSString).lastPathComponent
            formattedParts.append("(Func: \(function), Line: \(line))")
        }

        let formattedMessage = formattedParts.joined(separator: " ")
        print(formattedMessage)
    }
}