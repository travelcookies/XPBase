//
//  Codable+Ex.swift
//  XPBase
//
//  Created by 林小鹏 on 2026/1/15.
//
import Foundation

/// 使用方法示例：
/// ```swift
/// // 定义遵循 HandyCodable 协议的模型
/// struct User: HandyCodable {
///     var id: Int
///     var name: String
///     var email: String?
/// }
/// 
/// // 从 JSON 字符串解码
/// let jsonString = "{\"id\": 1, \"name\": \"John\", \"email\": \"john@example.com\"}"
/// if let user = User.decode(from: jsonString) {
///     print(user.name) // 输出 "John"
/// }
/// 
/// // 编码为 JSON 字符串
/// let user = User(id: 2, name: "Jane", email: "jane@example.com")
/// if let jsonString = user.encodeToJSONString(prettyPrint: true) {
///     print(jsonString)
/// }
/// 
/// // 编码为 JSON 字典
/// if let jsonDict = user.encodeToJSON() {
///     print(jsonDict)
/// }
/// ```

/// 自定义协议，封装序列化/反序列化方法
public protocol HandyCodable: Codable {
    /// 从 JSON 字符串解码为对象
    /// - Parameter jsonString: JSON 字符串
    /// - Returns: 解码后的对象
    static func decode(from jsonString: String) -> Self?
    
    /// 编码为 JSON 字符串
    /// - Parameter prettyPrint: 是否美化输出
    /// - Returns: 编码后的 JSON 字符串
    func encodeToJSONString(prettyPrint: Bool) -> String?
    
    /// 编码为 JSON 字典
    /// - Parameter prettyPrint: 是否美化输出
    /// - Returns: 编码后的 JSON 字典
    func encodeToJSON(prettyPrint: Bool) -> [String: Any]?
}

/// 扩展自定义协议，实现默认方法
public extension HandyCodable {
    static func decode(from jsonString: String) -> Self? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Self.self, from: data)
    }

    func encodeToJSONString(prettyPrint: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        guard let data = try? encoder.encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    func encodeToJSON(prettyPrint: Bool = false) -> [String: Any]? {
        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        guard let data = try? encoder.encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
    }
}

/// 示例模型
public struct BasicTypes: HandyCodable {
    public var int: Int = 2
    public var doubleOptional: Double?
    public var stringImplicitlyUnwrapped: String!
}

