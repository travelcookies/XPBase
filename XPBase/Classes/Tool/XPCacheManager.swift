import Foundation

/// 日志记录器
private let cacheLogger = XPLogger(category: "Cache")

/// 缓存管理器
/// 提供基于文件系统的缓存功能，支持线程安全的读写操作
/// 
/// 使用示例：
/// ```swift
/// // 创建缓存管理器实例
/// let cache = XPCacheManager(name: "MyCache")
/// 
/// // 保存缓存
/// cache.addUpdateCache(key: "user_info", value: userDictionary)
/// 
/// // 获取缓存
/// if let userInfo = cache.obtainCache(key: "user_info") as? [String: Any] {
///     print(userInfo)
/// }
/// 
/// // 删除指定缓存
/// cache.removeCache(key: "user_info")
/// 
/// // 清空所有缓存
/// cache.removeAllCache()
/// ```
public class XPCacheManager {
    private let cacheDirectory: String
    private let queue = DispatchQueue(label: "com.xpbase.cache")
    
    /// 初始化方法
    /// - Parameter name: 缓存名称，将作为缓存目录名
    public init(name: String) {
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let basePath = paths.first ?? NSTemporaryDirectory()
        cacheDirectory = (basePath as NSString).appendingPathComponent(name)
        
        createDirectoryIfNeeded()
    }
    
    private func createDirectoryIfNeeded() {
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(atPath: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            cacheLogger.error("Error creating cache directory: \(error.localizedDescription)")
        }
    }
    
    public func addUpdateCache(key: String, value: Any) {
        queue.sync {
            let filePath = (cacheDirectory as NSString).appendingPathComponent(key)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                try data.write(to: URL(fileURLWithPath: filePath))
            } catch {
                cacheLogger.error("Error saving cache: \(error.localizedDescription)")
            }
        }
    }
    
    public func obtainCache(key: String) -> Any? {
        return queue.sync {
            let filePath = (cacheDirectory as NSString).appendingPathComponent(key)
            guard FileManager.default.fileExists(atPath: filePath) else {
                return nil
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            } catch {
                cacheLogger.error("Error loading cache: \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    public func removeCache(key: String) {
        queue.sync {
            let filePath = (cacheDirectory as NSString).appendingPathComponent(key)
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch {
                cacheLogger.error("Error removing cache: \(error.localizedDescription)")
            }
        }
    }
    
    public func removeAllCache() {
        queue.sync {
            do {
                try FileManager.default.removeItem(atPath: cacheDirectory)
                createDirectoryIfNeeded()
            } catch {
                cacheLogger.error("Error removing all cache: \(error.localizedDescription)")
            }
        }
    }
}