//
//  Codable+Extension.swift
//  XPBase
//
//  Created by 林小鹏 on 2026/1/15.
//

import Foundation

/// 使用方法示例：
/// ```swift
/// struct User: Codable {
///     var id: Int
///     var name: String
///     var email: String?
/// }
/// 
/// // 从 JSON 字符串解码
/// let jsonString = "{\"id\": 1, \"name\": \"John\", \"email\": \"john@example.com\"}"
/// if let user = User.xp.decode(from: jsonString) {
///     print(user.name) // 输出 "John"
/// }
/// 
/// // 从 Data 解码
/// if let user = User.xp.decode(from: data) {
///     print(user.name)
/// }
/// 
/// // 编码为 JSON 字符串
/// let user = User(id: 2, name: "Jane", email: "jane@example.com")
/// if let jsonString = user.xp.encodeToJSONString(prettyPrint: true) {
///     print(jsonString)
/// }
/// 
/// // 编码为 JSON 字典
/// if let jsonDict = user.xp.encodeToJSON() {
///     print(jsonDict)
/// }
/// 
/// // 便捷属性
/// let jsonStr = user.xp.jsonString // 普通 JSON 字符串
/// let prettyStr = user.xp.prettyJSONString // 美化的 JSON 字符串
/// let jsonDict = user.xp.jsonDictionary // JSON 字典
/// ```

/// Encodable 类型扩展（XP命名空间版本）
public extension XP where Base: Encodable {
    /// 编码为 JSON 字符串
    /// - Parameter prettyPrint: 是否美化输出，默认 false
    /// - Returns: 编码后的 JSON 字符串
    func encodeToJSONString(prettyPrint: Bool = false) -> String? {
        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        guard let data = try? encoder.encode(base) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// 编码为 JSON 字典
    /// - Parameter prettyPrint: 是否美化输出，默认 false
    /// - Returns: 编码后的 JSON 字典
    func encodeToJSON(prettyPrint: Bool = false) -> [String: Any]? {
        let encoder = JSONEncoder()
        if prettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        guard let data = try? encoder.encode(base) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
    }
    
    /// 转换为 JSON 字符串（便捷方法）
    var jsonString: String? {
        return encodeToJSONString()
    }
    
    /// 转换为美化的 JSON 字符串
    var prettyJSONString: String? {
        return encodeToJSONString(prettyPrint: true)
    }
    
    /// 转换为 JSON 字典（便捷方法）
    var jsonDictionary: [String: Any]? {
        return encodeToJSON()
    }
}

/// Decodable 类型扩展（XP命名空间版本）
public extension XP where Base: Decodable {
    /// 从 JSON 字符串解码为对象
    /// - Parameter jsonString: JSON 字符串
    /// - Returns: 解码后的对象
    static func decode(from jsonString: String) -> Base? {
        guard let data = jsonString.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(Base.self, from: data)
    }
    
    /// 从 Data 解码为对象
    /// - Parameter data: JSON 数据
    /// - Returns: 解码后的对象
    static func decode(from data: Data) -> Base? {
        return try? JSONDecoder().decode(Base.self, from: data)
    }
}

/// 示例模型
public struct BasicTypes: Codable {
    public var int: Int = 2
    public var doubleOptional: Double?
    public var stringImplicitlyUnwrapped: String!
}

/// 为不遵循 XPCompatible 的 Encodable 类型提供 xp 属性访问
/// 注意：此扩展仅适用于未遵循 XPCompatible 的类型
public extension Encodable where Self: XPCompatible {
    // 空扩展 - XPCompatible 已经提供了 xp 属性
}

/// 为不遵循 XPCompatible 的 Decodable 类型提供 xp 属性访问
public extension Decodable where Self: XPCompatible {
    // 空扩展 - XPCompatible 已经提供了 xp 属性
}
