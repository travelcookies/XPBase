import UIKit
import MediaPlayer

/// MPMediaPickerController 工具类封装
/// 处理 iOS 13+ 的媒体库权限请求
class MediaPickerTool: NSObject {

    // MARK: - 类型定义
    typealias MediaPickerDidPickMediaItemsHandler = (_ mediaItemCollection: MPMediaItemCollection) -> Void
    typealias MediaPickerDidCancelHandler = () -> Void
    typealias MediaPickerAccessDeniedHandler = (_ status: MPMediaLibraryAuthorizationStatus) -> Void

    // MARK: - 属性
    private var mediaPicker: MPMediaPickerController?
    private var didPickMediaItemsHandler: MediaPickerDidPickMediaItemsHandler?
    private var didCancelHandler: MediaPickerDidCancelHandler?
    private var accessDeniedHandler: MediaPickerAccessDeniedHandler?
    private weak var presentingViewController: UIViewController?

    // MARK: - 公共方法

    /// 检查权限并展示媒体选择器 (主入口方法)
    /// - Parameters:
    ///   - viewController: 用于呈现选择器的视图控制器
    ///   - mediaTypes: 要显示的媒体类型，默认为音乐
    ///   - allowsPickingMultipleItems: 是否允许选择多个媒体项，默认为 false
    ///   - prompt: 选择器顶部显示的提示文字，可选
    ///   - didPickMediaItems: 成功选择媒体项的回调
    ///   - didCancel: 用户取消选择的回调
    ///   - accessDenied: 媒体库访问被拒绝或受限的回调（可选，提供更精细的状态）
    func presentMediaPicker(from viewController: UIViewController,
                           mediaTypes: MPMediaType = .music,
                           allowsPickingMultipleItems: Bool = false,
                           prompt: String? = "选择音乐",
                           didPickMediaItems: MediaPickerDidPickMediaItemsHandler?,
                           didCancel: MediaPickerDidCancelHandler?,
                           accessDenied: MediaPickerAccessDeniedHandler? = nil) {

        self.presentingViewController = viewController
        self.didPickMediaItemsHandler = didPickMediaItems
        self.didCancelHandler = didCancel
        self.accessDeniedHandler = accessDenied

        // 检查当前授权状态
        let currentStatus = MPMediaLibrary.authorizationStatus()

        switch currentStatus {
        case .authorized:
            // 已授权，直接呈现选择器
            self.presentMediaPickerController(mediaTypes: mediaTypes,
                                            allowsPickingMultipleItems: allowsPickingMultipleItems,
                                            prompt: prompt)
        case .notDetermined:
            // 尚未请求，先请求权限
            self.requestMediaLibraryAuthorization(mediaTypes: mediaTypes,
                                                allowsPickingMultipleItems: allowsPickingMultipleItems,
                                                prompt: prompt)
        case .denied, .restricted:
            // 已拒绝或受限，调用访问拒绝回调
            DispatchQueue.main.async {
                accessDenied?(currentStatus)
                // 可以在这里提示用户去设置中开启权限
                self.showAlertForPermissionSettings(status: currentStatus)
            }
        @unknown default:
            // 处理未来可能出现的未知状态
            DispatchQueue.main.async {
                accessDenied?(currentStatus)
            }
        }
    }

    /// 以模态方式 dismiss 媒体选择器
    func dismissMediaPicker(animated: Bool = true, completion: (() -> Void)? = nil) {
        mediaPicker?.dismiss(animated: animated, completion: completion)
        mediaPicker = nil // 释放引用
    }

    // MARK: - 私有方法

    /// 请求媒体库授权
    private func requestMediaLibraryAuthorization(mediaTypes: MPMediaType,
                                               allowsPickingMultipleItems: Bool,
                                               prompt: String?) {
        MPMediaLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    // 用户授权，呈现选择器
                    self.presentMediaPickerController(mediaTypes: mediaTypes,
                                                    allowsPickingMultipleItems: allowsPickingMultipleItems,
                                                    prompt: prompt)
                case .denied, .restricted, .notDetermined:
                    // 用户拒绝、受限或仍未决定，调用访问拒绝回调
                    self.accessDeniedHandler?(status)
                @unknown default:
                    self.accessDeniedHandler?(status)
                }
            }
        }
    }

    /// 创建并呈现 MPMediaPickerController
    private func presentMediaPickerController(mediaTypes: MPMediaType,
                                           allowsPickingMultipleItems: Bool,
                                           prompt: String?) {
        // 确保 presentingViewController 仍然有效
        guard let presentingVC = self.presentingViewController else {
            print("Error: Presenting view controller is nil.")
            return
        }

        mediaPicker = MPMediaPickerController(mediaTypes: mediaTypes)
        guard let mediaPicker = mediaPicker else { return }

        mediaPicker.delegate = self
        mediaPicker.allowsPickingMultipleItems = allowsPickingMultipleItems
        mediaPicker.prompt = prompt
        mediaPicker.showsCloudItems = false // 通常建议设置为false，避免用户选到无法访问的iCloud项目

        presentingVC.present(mediaPicker, animated: true, completion: nil)
    }

    /// 显示引导用户去设置中开启权限的提示框
    private func showAlertForPermissionSettings(status: MPMediaLibraryAuthorizationStatus) {
        guard let presentingVC = presentingViewController else { return }

        let alertTitle: String
        let alertMessage: String

        switch status {
        case .denied:
            alertTitle = "媒体库访问已关闭"
            alertMessage = "您需要开启媒体库访问权限才能选择音乐。请前往【设置】->【隐私与安全性】->【媒体与Apple Music】中，允许此应用访问您的媒体库。"
        case .restricted:
            alertTitle = "媒体库访问受限"
            alertMessage = "您的设备限制此应用访问媒体库。这可能是由于家长控制或设备策略所致。"
        default:
            return
        }

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "前往设置", style: .default) { _ in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(settingsAction)

        presentingVC.present(alert, animated: true, completion: nil)
    }
}

// MARK: - MPMediaPickerControllerDelegate
extension MediaPickerTool: MPMediaPickerControllerDelegate {

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // 调用成功的回调，将选中的媒体集合传递出去
        didPickMediaItemsHandler?(mediaItemCollection)
        // 自动 dismiss 选择器
        dismissMediaPicker(animated: true)
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        // 调用取消的回调
        didCancelHandler?()
        // 自动 dismiss 选择器
        dismissMediaPicker(animated: true)
    }
}
