//
//  BaseLog.swift
//  Alamofire
//
//  Created by 林小鹏 on 2025/12/15.
//

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

/// 统一日志封装，兼容 iOS 9 及以上所有版本
/// 根据系统版本自动选择合适的日志输出方式：iOS 10+ 使用 OSLog，iOS 9 使用 print
///
/// 使用示例：
/// ```swift
/// // 创建日志器实例（推荐按模块分类）
/// let networkLogger = XPLogger(category: "Network")
/// let uiLogger = XPLogger(category: "UI")
/// let dataLogger = XPLogger(category: "Data")
///
/// // 输出不同级别的日志
/// networkLogger.log("请求开始", level: .info)
/// networkLogger.log("请求参数: \(params)", level: .debug)
/// uiLogger.log("视图加载完成", level: .info)
/// dataLogger.log("数据解析失败", level: .error)
///
/// // 使用默认级别
/// networkLogger.log("普通日志消息")
///
/// // 自定义子系统
/// let customLogger = XPLogger(subsystem: "com.example.app.feature", category: "Feature")
/// customLogger.log("功能模块日志")
/// ```
public struct XPLogger {
    private let subsystem: String
    private let category: String
    private let useOSLog: Bool

    /// 默认子系统标识，使用应用的 Bundle ID
    public static var defaultSubsystem: String = {
        Bundle.main.bundleIdentifier ?? "com.yourapp.unknown"
    }()

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

    // MARK: - 公共日志方法

    public func log(_ message: String, level: LogLevel = .default, file: String = #file, function: String = #function, line: Int = #line) {
        if useOSLog {
            // iOS 10+ 路径：使用 OSLog
            osLog(message, level: level)
        } else {
            // iOS 9 降级路径：使用格式化的 print
            fallbackPrint(message, level: level, file: file, function: function, line: line)
        }
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
        // 注意：经典 os_log API 对字符串插值支持有限[citation:7]
        os_log("%{public}@", log: log, type: osLogType, message)
    }

    // MARK: - 降级实现 (iOS 9)

    private func fallbackPrint(_ message: String, level: LogLevel, file: String, function: String, line: Int) {
        // 提取文件名
        let fileName = (file as NSString).lastPathComponent
        // 格式化时间戳
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())

        // 构建格式化的输出字符串，模拟结构化日志[citation:1]
        let formattedMessage = String(format: "\(fileName) %@ %@ [%@] [%@] %@ (Func: %@, Line: %d)",
                                      timestamp,
                                      level.icon,
                                      subsystem,
                                      category,
                                      message,
                                      function,
                                      line)

        // 使用 print 输出，在Xcode控制台可见
        print(formattedMessage)

        // 可选：如果需要更接近系统日志的行为，也可以使用 NSLog。
        // 但注意NSLog会输出时间、进程等额外信息，可能会造成重复。
        // NSLog("%@", formattedMessage)
    }
}
