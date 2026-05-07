import UIKit
import AVFoundation

/// 图片工具类（XP命名空间版本）
/// 提供图片创建、缩放、视频封面获取等便捷方法
///
/// 使用示例：
/// ```swift
/// // 创建纯色图片（1x1像素）
/// let redImage = XPImage.image(with: .red)
/// 
/// // 创建指定尺寸的纯色图片
/// let blueImage = XPImage.image(with: .blue, size: CGSize(width: 100, height: 100))
/// 
/// // 缩放图片到指定尺寸
/// let scaledImage = XPImage.scale(image: originalImage, toSize: CGSize(width: 200, height: 200))
/// 
/// // 获取视频封面图
/// if let previewImage = XPImage.getVideoPreviewImage(with: videoURL) {
///     imageView.image = previewImage
/// }
/// 
/// // 获取启动页图片
/// if let launchImage = XPImage.getLaunchImage() {
///     // 使用启动页图片
/// }
/// 
/// // 获取应用图标
/// if let appIcon = XPImage.getAppIcon() {
///     // 使用应用图标
/// }
/// ```
public struct XPImage {
    /// 创建纯色图片（1x1像素）
    public static func image(with color: UIColor) -> UIImage {
        return image(with: color, size: CGSize(width: 1, height: 1))
    }
    
    public static func image(with color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    public static func scale(image: UIImage, toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? image
    }
    
    public static func getVideoPreviewImage(with path: URL) -> UIImage? {
        let asset = AVURLAsset(url: path)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(0.0, 600)
        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            return nil
        }
    }
    
    public static func getLaunchImage() -> UIImage? {
        var launchImage: UIImage?
        let orientation: String
        let scale = UIScreen.main.scale
        let screenSize = UIScreen.main.bounds.size
        
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.windows.first?.windowScene
            orientation = windowScene?.interfaceOrientation.isLandscape ?? false ? "Landscape" : "Portrait"
        } else {
            orientation = UIApplication.shared.statusBarOrientation.isLandscape ? "Landscape" : "Portrait"
        }
        
        if let imagesInfo = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] {
            for info in imagesInfo {
                if let imageSizeStr = info["UILaunchImageSize"] as? String,
                   let imageOrientation = info["UILaunchImageOrientation"] as? String,
                   imageOrientation == orientation {
                    let imageSize = CGSizeFromString(imageSizeStr)
                    if imageSize.equalTo(screenSize) {
                        if let imageName = info["UILaunchImageName"] as? String {
                            launchImage = UIImage(named: imageName)
                            if launchImage?.scale == scale {
                                break
                            }
                        }
                    }
                }
            }
        }
        
        return launchImage
    }
    
    public static func getAppIcon() -> UIImage? {
        if let infoPlist = Bundle.main.infoDictionary as NSDictionary?,
           let iconFiles = infoPlist.value(forKeyPath: "CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles") as? [String],
           let iconName = iconFiles.last {
            return UIImage(named: iconName)
        }
        return nil
    }
}