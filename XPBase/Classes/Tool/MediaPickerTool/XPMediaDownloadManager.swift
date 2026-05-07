import UIKit
import Alamofire
import Photos

/// 媒体类型枚举
public enum XPMediaType {
    case image
    case video
}

/// 下载进度回调
public typealias XPDownloadProgressHandler = (Double) -> Void
/// 下载完成回调
public typealias XPDownloadCompletionHandler = (Result<URL, Error>) -> Void
/// 保存完成回调
public typealias XPSaveCompletionHandler = (Bool, Error?) -> Void

/// 媒体下载错误类型
public enum XPMediaDownloadError: Error, LocalizedError {
    case invalidURL
    case invalidImageData
    case videoNotCompatible
    case fileNotFound
    case permissionDenied
    case saveFailed

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "无效的URL地址"
        case .invalidImageData:
            return "图片数据格式错误"
        case .videoNotCompatible:
            return "视频格式不兼容"
        case .fileNotFound:
            return "文件未找到"
        case .permissionDenied:
            return "相册权限被拒绝"
        case .saveFailed:
            return "保存到相册失败"
        }
    }
}

/// 媒体下载工具类（XP命名空间版本）
/// 提供媒体文件下载和保存到相册的功能，支持进度回调和权限处理
///
/// 使用示例：
/// ```swift
/// // 下载并保存图片到相册
/// XPMediaDownloadManager.shared.downloadImage(
///     urlString: "https://example.com/image.jpg",
///     progressHandler: { progress in
///         print("下载进度: \(progress * 100)%")
///     }, completion: { success, error in
///         if success {
///             print("图片保存成功")
///         } else {
///             print("保存失败: \(error?.localizedDescription ?? "未知错误")")
///         }
///     }
/// )
///
/// // 下载并保存视频到相册
/// XPMediaDownloadManager.shared.downloadVideo(
///     urlString: "https://example.com/video.mp4",
///     progressHandler: { progress in
///         print("下载进度: \(progress * 100)%")
///     }, completion: { success, error in
///         if success {
///             print("视频保存成功")
///         } else {
///             print("保存失败: \(error?.localizedDescription ?? "未知错误")")
///         }
///     }
/// )
///
/// // 取消下载
/// XPMediaDownloadManager.shared.cancelDownload("https://example.com/image.jpg")
///
/// // 清理临时文件
/// XPMediaDownloadManager.shared.cleanupTempFiles()
/// ```
public final class XPMediaDownloadManager: NSObject {

    // MARK: - 单例模式
    public static let shared = XPMediaDownloadManager()
    private override init() {
        super.init()
    }

    // MARK: - 私有属性
    private var activeDownloads: [String: DownloadRequest] = [:]
    private var completionHandlers: [String: XPSaveCompletionHandler] = [:]
    private let fileManager = FileManager.default
    private let syncQueue = DispatchQueue(label: "com.yourapp.XPMediaDownloadManager.syncQueue")

    // MARK: - 公共方法

    /// 下载并保存媒体文件到相册
    public func downloadAndSaveMedia(
        urlString: String,
        mediaType: XPMediaType,
        progressHandler: XPDownloadProgressHandler? = nil,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // 检查URL有效性
        guard let url = URL(string: urlString) else {
            completion(false, XPMediaDownloadError.invalidURL)
            return
        }

        // 先检查相册权限
        checkPhotoLibraryPermission { [weak self] hasPermission in
            guard let self = self else { return }

            guard hasPermission else {
                completion(false, XPMediaDownloadError.permissionDenied)
                return
            }

            // 开始下载
            self.downloadFile(from: url, progressHandler: progressHandler) { result in
                switch result {
                case .success(let localURL):
                    // 下载成功，保存到相册
                    self.saveToPhotoAlbum(
                        fileURL: localURL,
                        mediaType: mediaType,
                        originalURL: urlString,
                        completion: completion
                    )

                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }

    /// 仅下载文件到临时目录
    public func downloadFile(
        from url: URL,
        progressHandler: XPDownloadProgressHandler? = nil,
        completion: @escaping XPDownloadCompletionHandler
    ) {
        let destination: DownloadRequest.Destination = { _, _ in
            let tempDirectory = self.fileManager.temporaryDirectory
            let fileName = UUID().uuidString + "." + url.pathExtension
            let fileURL = tempDirectory.appendingPathComponent(fileName)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        let downloadRequest = AF.download(url, to: destination)
            .downloadProgress { progress in
                progressHandler?(progress.fractionCompleted)
            }
            .response { [weak self] response in
                self?.syncQueue.async {
                    self?.activeDownloads.removeValue(forKey: url.absoluteString)
                }

                switch response.result {
                case .success(let localURL):
                    if let localURL = localURL {
                        completion(.success(localURL))
                    } else {
                        completion(.failure(XPMediaDownloadError.fileNotFound))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }

        syncQueue.async {
            self.activeDownloads[url.absoluteString] = downloadRequest
        }
    }

    /// 取消下载任务
    public func cancelDownload(_ urlString: String) {
        syncQueue.async {
            if let downloadRequest = self.activeDownloads[urlString] {
                downloadRequest.cancel()
                self.activeDownloads.removeValue(forKey: urlString)
            }
        }
    }

    // MARK: - 私有方法

    /// 保存文件到系统相册
    private func saveToPhotoAlbum(
        fileURL: URL,
        mediaType: XPMediaType,
        originalURL: String,
        completion: @escaping XPSaveCompletionHandler
    ) {
        // 使用UUID作为key来存储completion handler
        let handlerKey = UUID().uuidString

        syncQueue.async {
            self.completionHandlers[handlerKey] = completion
        }

        switch mediaType {
        case .image:
            saveImageToPhotoAlbum(fileURL: fileURL, handlerKey: handlerKey)
        case .video:
            saveVideoToPhotoAlbum(fileURL: fileURL, handlerKey: handlerKey)
        }
    }

    /// 保存图片到相册
    private func saveImageToPhotoAlbum(fileURL: URL, handlerKey: String) {
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            callCompletionHandler(for: handlerKey, success: false, error: XPMediaDownloadError.invalidImageData)
            return
        }

        // 使用简化版的调用，避免内存管理问题
        UIImageWriteToSavedPhotosAlbum(
            image,
            self,
            #selector(image(_:didFinishSavingWithError:contextInfo:)),
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )

        // 存储handlerKey用于后续查找
        syncQueue.async {
            // 这里可以存储额外的上下文信息如果需要
        }
    }

    /// 保存视频到相册
    private func saveVideoToPhotoAlbum(fileURL: URL, handlerKey: String) {
        guard UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(fileURL.path) else {
            callCompletionHandler(for: handlerKey, success: false, error: XPMediaDownloadError.videoNotCompatible)
            return
        }

        UISaveVideoAtPathToSavedPhotosAlbum(
            fileURL.path,
            self,
            #selector(video(_:didFinishSavingWithError:contextInfo:)),
            UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        )
    }

    // MARK: - 保存完成回调（iOS标准方式）

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        handleSaveCompletion(error: error)
    }

    @objc private func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        handleSaveCompletion(error: error)
    }

    private func handleSaveCompletion(error: Error?) {
        // 这里简化处理，实际项目中可能需要更复杂的逻辑来匹配具体的completion handler
        // 对于简单用例，可以广播通知或者使用其他方式

        let success = error == nil
        // 通知所有等待的completion handlers（简化版）
        notifyAllCompletionHandlers(success: success, error: error)
    }

    private func notifyAllCompletionHandlers(success: Bool, error: Error?) {
        syncQueue.async {
            let handlers = self.completionHandlers
            self.completionHandlers.removeAll()

            DispatchQueue.main.async {
                for (_, handler) in handlers {
                    handler(success, error)
                }
            }
        }
    }

    private func callCompletionHandler(for key: String, success: Bool, error: Error?) {
        syncQueue.async {
            if let handler = self.completionHandlers.removeValue(forKey: key) {
                DispatchQueue.main.async {
                    handler(success, error)
                }
            }
        }
    }

    // MARK: - 清理方法

    public func cleanup() {
        syncQueue.async {
            // 取消所有下载
            for downloadRequest in self.activeDownloads.values {
                downloadRequest.cancel()
            }
            self.activeDownloads.removeAll()

            // 清理completion handlers
            self.completionHandlers.removeAll()
        }

        cleanupTempFiles()
    }

    public func cleanupTempFiles() {
        let tempDirectory = fileManager.temporaryDirectory

        do {
            let fileURLs = try fileManager.contentsOfDirectory(
                at: tempDirectory,
                includingPropertiesForKeys: nil
            )

            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
        } catch {
            print("清理临时文件失败: \(error)")
        }
    }
}

// MARK: - 使用示例扩展
extension XPMediaDownloadManager {

    public func downloadImage(
        urlString: String,
        progressHandler: XPDownloadProgressHandler? = nil,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        downloadAndSaveMedia(
            urlString: urlString,
            mediaType: .image,
            progressHandler: progressHandler,
            completion: completion
        )
    }

    public func downloadVideo(
        urlString: String,
        progressHandler: XPDownloadProgressHandler? = nil,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        downloadAndSaveMedia(
            urlString: urlString,
            mediaType: .video,
            progressHandler: progressHandler,
            completion: completion
        )
    }
}

// MARK: - 相册权限检查
extension XPMediaDownloadManager {

    public func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            switch status {
            case .authorized, .limited:
                completion(true)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized || newStatus == .limited)
                    }
                }
            case .denied, .restricted:
                completion(false)
            @unknown default:
                completion(false)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .authorized:
                completion(true)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized)
                    }
                }
            case .denied, .restricted:
                completion(false)
            case .limited:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
}

// MARK: - 替代方案：使用Photos框架（推荐）
extension XPMediaDownloadManager {

    /// 使用Photos框架保存图片（更现代的方式）
    private func saveImageWithPhotosFramework(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    /// 使用Photos框架保存视频（更现代的方式）
    private func saveVideoWithPhotosFramework(videoURL: URL, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }

    /// 使用Photos框架的下载和保存方法（推荐）
    public func downloadAndSaveWithPhotosFramework(
        urlString: String,
        mediaType: XPMediaType,
        progressHandler: XPDownloadProgressHandler? = nil,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(false, XPMediaDownloadError.invalidURL)
            return
        }

        checkPhotoLibraryPermission { [weak self] hasPermission in
            guard let self = self, hasPermission else {
                completion(false, XPMediaDownloadError.permissionDenied)
                return
            }

            self.downloadFile(from: url, progressHandler: progressHandler) { result in
                switch result {
                case .success(let localURL):
                    switch mediaType {
                    case .image:
                        if let image = UIImage(contentsOfFile: localURL.path) {
                            self.saveImageWithPhotosFramework(image: image, completion: completion)
                        } else {
                            completion(false, XPMediaDownloadError.invalidImageData)
                        }
                    case .video:
                        self.saveVideoWithPhotosFramework(videoURL: localURL, completion: completion)
                    }

                case .failure(let error):
                    completion(false, error)
                }
            }
        }
    }
}
