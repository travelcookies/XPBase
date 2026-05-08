import UIKit

extension UIImage: XPCompatible {}

public extension XP where Base == UIImage {
    func compressed(toByte maxLength: Int) -> UIImage {
        guard var data = UIImageJPEGRepresentation(base, 1) else { return base }
        
        if data.count < maxLength { return base }
        
        var compression: CGFloat = 1
        var max: CGFloat = 1
        var min: CGFloat = 0
        
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = UIImageJPEGRepresentation(base, compression)!
            
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        
        if let image = UIImage(data: data) {
            return image
        }
        return base
    }
    
    func scaled(toMaxWidth width: CGFloat, maxHeight height: CGFloat) -> UIImage {
        let size = base.size
        let widthRatio = width / size.width
        let heightRatio = height / size.height
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        base.draw(in: CGRect(origin: .zero, size: newSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage ?? base
    }
    
    func resize(to targetSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        base.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? base
    }
}