//
//  Codable拓展.swift
//  Pods
//
//  Created by 林小鹏 on 2026/1/15.
//
import Foundation

//// 1. 定义自定义协议，封装序列化/反序列化方法
//protocol HandyCodable: Codable {
//    static func decode(from jsonString: String) -> Self?
//    func encodeToJSONString(prettyPrint: Bool) -> String?
//    func encodeToJSON(prettyPrint: Bool) -> [String: Any]?
//}
//
//// 2. 扩展自定义协议，实现默认方法
//extension HandyCodable {
//    static func decode(from jsonString: String) -> Self? {
//        guard let data = jsonString.data(using: .utf8) else { return nil }
//        return try? JSONDecoder().decode(Self.self, from: data)
//    }
//
//    func encodeToJSONString(prettyPrint: Bool = false) -> String? {
//        let encoder = JSONEncoder()
//        if prettyPrint {
//            encoder.outputFormatting = .prettyPrinted
//        }
//        guard let data = try? encoder.encode(self) else { return nil }
//        return String(data: data, encoding: .utf8)
//    }
//
//    func encodeToJSON(prettyPrint: Bool = false) -> [String: Any]? {
//        let encoder = JSONEncoder()
//        if prettyPrint {
//            encoder.outputFormatting = .prettyPrinted
//        }
//        guard let data = try? encoder.encode(self) else { return nil }
//        return try? JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
//    }
//}
//
//// 3. 模型遵循自定义协议（仅多写一个 HandyCodable，仍极简）
//struct BasicTypes: HandyCodable {
//    var int: Int = 2
//    var doubleOptional: Double?
//    var stringImplicitlyUnwrapped: String!
//}

//// 测试使用（语法完全不变）
// let jsonString = "{\"doubleOptional\":1.1,\"stringImplicitlyUnwrapped\":\"hello\",\"int\":1}"
// if let object = BasicTypes.decode(from: jsonString) {
//    print(object.int) // 输出 1
// }
