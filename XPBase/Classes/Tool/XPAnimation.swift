import UIKit

/// 动画工具类（XP命名空间版本）
/// 提供常用的缩放、旋转、透明度等动画效果
///
/// 使用示例：
/// ```swift
/// // 由大变小再恢复的动画
/// view.layer.add(XPAnimation.bigToSmallRecovery(), forKey: "scale")
/// 
/// // 由小变大再变小的动画
/// view.layer.add(XPAnimation.smallToBigToSmall(), forKey: "scale")
/// 
/// // 原始大小缩小的动画
/// view.layer.add(XPAnimation.originToSmall(), forKey: "scale")
/// 
/// // 原始大小变大变小再恢复的动画
/// view.layer.add(XPAnimation.originToBigToSmallRecovery(), forKey: "scale")
/// 
/// // 触摸按下的脉冲动画（循环）
/// view.layer.add(XPAnimation.touchDownAnimation(), forKey: "pulse")
/// 
/// // 旋转动画
/// view.layer.add(XPAnimation.rotationAnimation(duration: 3), forKey: "rotation")
/// 
/// // 头像缩放动画（循环）
/// view.layer.add(XPAnimation.avatarScaleAnimation(), forKey: "avatarScale")
/// 
/// // 透明度动画
/// view.layer.add(XPAnimation.opacityAnimation(from: 0, to: 1, duration: 0.3), forKey: "fadeIn")
/// 
/// // 缩放动画
/// view.layer.add(XPAnimation.scaleAnimation(from: 0.5, to: 1, duration: 0.3), forKey: "scaleUp")
/// ```
public struct XPAnimation {
    /// 由大变小再恢复的动画效果
    public static func bigToSmallRecovery() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 1
        
        let values: [NSValue] = [
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0))
        ]
        animation.values = values
        return animation
    }
    
    /// 由小变大再变小的动画效果
    public static func smallToBigToSmall() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 1.0
        
        let values: [NSValue] = [
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        ]
        animation.values = values
        return animation
    }
    
    /// 原始大小缩小的动画效果
    public static func originToSmall() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.2
        
        let values: [NSValue] = [
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0))
        ]
        animation.values = values
        return animation
    }
    
    /// 原始大小变大变小再恢复的动画效果
    public static func originToBigToSmallRecovery() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.5
        
        let values: [NSValue] = [
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.3, 0.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(0.7, 0.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0))
        ]
        animation.values = values
        return animation
    }
    
    /// 触摸按下的脉冲动画效果（循环播放）
    public static func touchDownAnimation() -> CAAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 1
        animation.repeatCount = .greatestFiniteMagnitude
        
        let values: [NSValue] = [
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.6, 1.6, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.7, 1.7, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.6, 1.6, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.4, 1.4, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.3, 1.3, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
            NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1.0))
        ]
        animation.values = values
        return animation
    }
    
    /// 旋转动画效果（循环播放）
    public static func rotationAnimation(duration: Double = 5) -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.toValue = NSNumber(value: 2 * Double.pi)
        rotate.duration = duration
        rotate.repeatCount = .greatestFiniteMagnitude
        return rotate
    }
    
    /// 头像缩放动画效果（循环播放）
    public static func avatarScaleAnimation() -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.duration = 1
        animation.repeatCount = .greatestFiniteMagnitude
        animation.values = [1.0, 1.1, 1.0, 0.9, 1.0]
        return animation
    }
    
    /// 透明度动画效果
    public static func opacityAnimation(from start: Float, to end: Float, duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = start
        animation.toValue = end
        animation.duration = duration
        return animation
    }
    
    /// 缩放动画效果
    public static func scaleAnimation(from start: CGFloat, to end: CGFloat, duration: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = start
        animation.toValue = end
        animation.duration = duration
        return animation
    }
}