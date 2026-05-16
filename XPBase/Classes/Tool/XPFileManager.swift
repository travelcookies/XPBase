import Foundation

/// 日志记录器
private let logger = XPLogger(category: "FileManager")

/// 文件管理器工具类
/// 提供文件系统常用操作，包括目录获取、文件删除、文件大小计算等
/// 
/// 使用示例：
/// ```swift
/// // 获取常用目录路径
/// let docsPath = XPFileManager.shared.documentsDirectory
/// let cachePath = XPFileManager.shared.cacheDirectory
/// let tempPath = XPFileManager.shared.temporaryDirectory
/// 
/// // 检查文件是否存在
/// let exists = XPFileManager.shared.fileExists(atPath: filePath)
/// 
/// // 获取文件大小
/// let size = XPFileManager.shared.fileSize(atPath: filePath)
/// 
/// // 删除文件夹中所有文件
/// XPFileManager.shared.removeAllFiles(in: cachePath)
/// 
/// // 删除指定扩展名的文件
/// XPFileManager.shared.removeAllFiles(in: tempPath, withExtension: ".tmp")
/// 
/// // 创建目录
/// try XPFileManager.shared.createDirectory(atPath: customPath)
/// 
/// // 复制文件
/// try XPFileManager.shared.copyFile(from: sourcePath, to: destPath)
/// ```
public class XPFileManager: NSObject {
    /// 单例实例
    public static let shared = XPFileManager()
    
    /// 文档目录路径
    public var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    /// 缓存目录路径
    public var cacheDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    /// 临时目录路径
    public var temporaryDirectory: String {
        return NSTemporaryDirectory()
    }
    
    /// 删除文件夹中的所有文件
    /// - Parameters:
    ///   - folderPath: 文件夹路径
    ///   - ext: 可选的文件扩展名过滤，为 nil 时删除所有文件
    public func removeAllFiles(in folderPath: String, withExtension ext: String? = nil) {
        let fileManager = FileManager.default
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
            
            for fileName in contents {
                if let ext = ext, !fileName.hasSuffix(ext) {
                    continue
                }
                
                let filePath = (folderPath as NSString).appendingPathComponent(fileName)
                try fileManager.removeItem(atPath: filePath)
            }
        } catch {
            logger.error("Error removing files: \(error.localizedDescription)")
        }
    }
    
    public func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    public func fileSize(atPath path: String) -> UInt64 {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: path),
              let size = attrs[.size] as? UInt64 else {
            return 0
        }
        return size
    }
    
    public func createDirectory(atPath path: String) throws {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    public func copyFile(from sourcePath: String, to destinationPath: String) throws {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: destinationPath) {
            try fileManager.removeItem(atPath: destinationPath)
        }
        
        try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
    }
}