//
//  NetworkLoggerPlugin.swift
//  TheWay
//
//  Created on 2026/05/06.
//

import Foundation
import Moya

/// 网络请求日志插件
/// 用于格式化打印 Moya 请求和响应的详细信息
final class NetworkLoggerPlugin: PluginType {
    
    /// 请求发送前调用
    /// - Parameters:
    ///   - request: 请求对象
    ///   - target: API 目标
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        // 获取请求体
        let requestBody = fetchRequestBody(from: request)
        
        // 获取请求头
        let requestHeaders = fetchRequestHeaders(from: request)
        
        print("""
        
        🚀 ═══════════════════════════════════════════
        🚀 API Request
        🚀 ═══════════════════════════════════════════
        📍 Target: \(target)
        🔗 Path: \(target.path)
        📝 Method: \(target.method.rawValue.uppercased())
        🌐 Base URL: \(target.baseURL.absoluteString)
        📦 Headers: \(requestHeaders ?? target.headers ?? [:])
        📤 Body: \(requestBody ?? "nil")
        🚀 ═══════════════════════════════════════════
        """)
        #endif
    }
    
    /// 响应接收后调用
    /// - Parameters:
    ///   - result: 响应结果
    ///   - target: API 目标
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case .success(let response):
            let responseBody = fetchResponseBody(from: response)
            
            print("""
            
            ✅ ═══════════════════════════════════════════
            ✅ API Response
            ✅ ═══════════════════════════════════════════
            📍 Target: \(target)
            🔗 Path: \(target.path)
            💻 Status Code: \(response.statusCode)
            📥 Response: \(responseBody ?? "nil")
            ✅ ═══════════════════════════════════════════
            """)
            
        case .failure(let error):
            print("""
            
            ❌ ═══════════════════════════════════════════
            ❌ API Error
            ❌ ═══════════════════════════════════════════
            📍 Target: \(target)
            🔗 Path: \(target.path)
            💻 Status Code: \(error.response?.statusCode ?? 0)
            🐛 Error: \(error.errorDescription ?? "Unknown Error")
            ❌ ═══════════════════════════════════════════
            """)
        }
        #endif
    }
    
    // MARK: - Private Methods
    
    /// 从请求中获取请求体
    private func fetchRequestBody(from request: RequestType) -> String? {
        guard let bodyData = request.request?.httpBody else { return nil }
        return String(data: bodyData, encoding: .utf8)
    }
    
    /// 从请求中获取请求头
    private func fetchRequestHeaders(from request: RequestType) -> [String: String]? {
        return request.request?.allHTTPHeaderFields
    }
    
    /// 从响应中获取响应体
    private func fetchResponseBody(from response: Response) -> String? {
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
