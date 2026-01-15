//
//  BaseLog.swift
//  Alamofire
//
//  Created by 林小鹏 on 2025/12/15.
//

import Foundation
import os.log

/// 日志级别枚举
public enum LogLevel: String, CaseIterable {
    case debug
    case info
    case `default`
    case error
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
public struct XPLogger {
    private let subsystem: String
    private let category: String
    private let useOSLog: Bool

    public static var defaultSubsystem: String = {
        Bundle.main.bundleIdentifier ?? "com.yourapp.unknown"
    }()

    /// 初始化日志器
    /// - Parameters:
    ///   - subsystem: 子系统标识，通常使用Bundle ID
    ///   - category: 日志分类，如“Network”、“UI”
    public init(subsystem: String = XPLogger.defaultSubsystem, category: String) {
        self.subsystem = subsystem
        self.category = category

        // 核心判断：iOS 10.0 及以上才使用 OSLog
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
