//
//  XPNetworkLoggerPlugin.swift
//  TheWay
//
//  Created on 2026/05/06.
//

import Foundation
import Moya

/// 网络请求日志插件配置
public struct XPNetworkLoggerConfig {
    /// 是否启用日志（默认 true，仅在 DEBUG 模式下生效）
    public var isEnabled: Bool = true
    /// 是否打印请求信息
    public var logRequest: Bool = true
    /// 是否打印响应信息
    public var logResponse: Bool = true
    /// 是否打印请求头（可能包含敏感信息，默认 false）
    public var logHeaders: Bool = false
    /// 自定义日志输出闭包（默认使用 print）
    public var logHandler: ((String) -> Void)?
    
    /// 默认配置
    public static let `default` = XPNetworkLoggerConfig()
}

/// 网络请求日志插件
/// 用于格式化打印 Moya 请求和响应的详细信息
///
/// 使用示例：
/// ```swift
/// // 使用默认配置
/// let loggerPlugin = XPNetworkLoggerPlugin()
/// let provider = MoyaProvider<MyAPI>(plugins: [loggerPlugin])
///
/// // 使用自定义配置
/// var config = XPNetworkLoggerConfig()
/// config.logHeaders = true
/// config.logHandler = { message in
///     // 自定义日志输出，如写入文件或发送到服务器
///     print("Custom Log: \(message)")
/// }
/// let customLogger = XPNetworkLoggerPlugin(config: config)
/// ```
public final class XPNetworkLoggerPlugin: PluginType {
    
    /// 日志配置
    public let config: XPNetworkLoggerConfig
    
    /// 初始化方法（使用默认配置）
    public convenience init() {
        self.init(config: .default)
    }
    
    /// 初始化方法（使用自定义配置）
    /// - Parameter config: 日志配置
    public init(config: XPNetworkLoggerConfig) {
        self.config = config
    }
    
    /// 请求发送前调用
    /// - Parameters:
    ///   - request: 请求对象
    ///   - target: API 目标
    public func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        guard config.isEnabled && config.logRequest else { return }
        
        let requestBody = XPNetworkLoggerPlugin.fetchRequestBody(from: request)
        let requestHeaders = config.logHeaders ? XPNetworkLoggerPlugin.fetchRequestHeaders(from: request) : nil
        
        let message = """
        
        🚀 ═══════════════════════════════════════════
        🚀 API Request
        🚀 ═══════════════════════════════════════════
        📍 Target: \(target)
        🔗 Path: \(target.path)
        📝 Method: \(target.method.rawValue.uppercased())
        🌐 Base URL: \(target.baseURL.absoluteString)\(config.logHeaders ? "\n📦 Headers: \(requestHeaders ?? target.headers ?? [:])" : "")
        📤 Body: \(requestBody ?? "nil")
        🚀 ═══════════════════════════════════════════
        """
        
        log(message)
        #endif
    }
    
    /// 响应接收后调用
    /// - Parameters:
    ///   - result: 响应结果
    ///   - target: API 目标
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        guard config.isEnabled && config.logResponse else { return }
        
        switch result {
        case .success(let response):
            let responseBody = XPNetworkLoggerPlugin.fetchResponseBody(from: response)
            
            let message = """
            
            ✅ ═══════════════════════════════════════════
            ✅ API Response
            ✅ ═══════════════════════════════════════════
            📍 Target: \(target)
            🔗 Path: \(target.path)
            💻 Status Code: \(response.statusCode)
            📥 Response: \(responseBody ?? "nil")
            ✅ ═══════════════════════════════════════════
            """
            
            log(message)
            
        case .failure(let error):
            let errorMessage = """
            
            ❌ ═══════════════════════════════════════════
            ❌ API Error
            ❌ ═══════════════════════════════════════════
            📍 Target: \(target)
            🔗 Path: \(target.path)
            💻 Status Code: \(error.response?.statusCode ?? 0)
            🐛 Error: \(error.errorDescription ?? "Unknown Error")
            ❌ ═══════════════════════════════════════════
            """
            
            log(errorMessage)
        }
        #endif
    }
    
    /// 输出日志
    /// - Parameter message: 日志消息
    private func log(_ message: String) {
        if let handler = config.logHandler {
            handler(message)
        } else {
            let pluginLogger = XPLogger(category: "Network")
            pluginLogger.debug(message)
        }
    }
}

// MARK: - 扩展：提供公共的日志数据获取方法

public extension XPNetworkLoggerPlugin {
    
    /// 从请求中获取请求体（公共方法）
    /// - Parameter request: 请求对象
    /// - Returns: 请求体字符串（如果存在）
    static func fetchRequestBody(from request: RequestType) -> String? {
        guard let bodyData = request.request?.httpBody else { return nil }
        return String(data: bodyData, encoding: .utf8)
    }
    
    /// 从请求中获取请求头（公共方法）
    /// - Parameter request: 请求对象
    /// - Returns: 请求头字典（如果存在）
    static func fetchRequestHeaders(from request: RequestType) -> [String: String]? {
        return request.request?.allHTTPHeaderFields
    }
    
    /// 从响应中获取响应体（公共方法）
    /// - Parameter response: 响应对象
    /// - Returns: 响应体字符串（如果存在）
    static func fetchResponseBody(from response: Response) -> String? {
        // 尝试解析为 JSON
        if let json = try? JSONSerialization.jsonObject(with: response.data, options: []),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        // 如果 JSON 解析失败，尝试作为字符串返回
        return String(data: response.data, encoding: .utf8)
    }
}
