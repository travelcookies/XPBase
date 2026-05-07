import Foundation
import Security

/// KeyChain 工具类
/// 提供安全的数据存储功能，基于 iOS KeyChain 服务实现
/// 
/// 使用示例：
/// ```swift
/// // 保存数据
/// let data = "secret_data".data(using: .utf8)!
/// let status = XPKeyChain.save(service: "MyApp", data: data)
/// if status == errSecSuccess {
///     print("保存成功")
/// }
/// 
/// // 读取数据
/// if let loadedData = XPKeyChain.load(service: "MyApp") {
///     let value = String(data: loadedData, encoding: .utf8)
///     print(value ?? "")
/// }
/// 
/// // 删除数据
/// XPKeyChain.delete(service: "MyApp")
/// 
/// // 快捷方法保存字符串
/// let success = XPKeyChain.saveString(service: "token", value: "abc123")
/// 
/// // 快捷方法读取字符串
/// let token = XPKeyChain.loadString(service: "token")
/// ```
public class XPKeyChain {
    /// 保存数据到 KeyChain
    /// - Parameters:
    ///   - service: 服务标识符
    ///   - data: 要保存的数据
    /// - Returns: 操作状态码，errSecSuccess 表示成功
    public class func save(service: String, data: Data) -> OSStatus {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecValueData: data,
            kSecAttrAccount: service
        ]
        
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }
    
    public class func load(service: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: service,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var data: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        
        return status == errSecSuccess ? data as? Data : nil
    }
    
    public class func delete(service: String) -> OSStatus {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: service
        ]
        
        return SecItemDelete(query as CFDictionary)
    }
    
    public class func saveString(service: String, value: String) -> Bool {
        if let data = value.data(using: .utf8) {
            return save(service: service, data: data) == errSecSuccess
        }
        return false
    }
    
    public class func loadString(service: String) -> String? {
        if let data = load(service: service) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}