import UIKit

/// 渐变背景视图（XP命名空间版本）
/// 继承自 UIView，支持渐变背景色，支持在 Interface Builder 中可视化配置
///
/// 使用示例：
/// ```swift
/// // 创建渐变视图
/// let gradientView = XPGradientView()
/// gradientView.setGradient(startColor: .red, endColor: .orange)
/// view.addSubview(gradientView)
/// 
/// // 自定义渐变方向（从右上到左下）
/// gradientView.setGradient(startColor: .blue, endColor: .purple, 
///                         startPoint: CGPoint(x: 1, y: 0), 
///                         endPoint: CGPoint(x: 0, y: 1))
/// ```
@IBDesignable
public class XPGradientView: UIView {
    /// 是否启用渐变（默认 false）
    @IBInspectable public var isGradient: Bool = false
    /// 渐变起始颜色（默认白色）
    @IBInspectable public var startColor: UIColor = .white
    /// 渐变结束颜色（默认白色）
    @IBInspectable public var endColor: UIColor = .white
    /// 起始点 X 坐标（0-1）
    @IBInspectable public var startPointX: CGFloat = 0 {
        didSet { startPoint = CGPoint(x: startPointX, y: startPointY) }
    }
    /// 起始点 Y 坐标（0-1）
    @IBInspectable public var startPointY: CGFloat = 0 {
        didSet { startPoint = CGPoint(x: startPointX, y: startPointY) }
    }
    /// 结束点 X 坐标（0-1）
    @IBInspectable public var endPointX: CGFloat = 1 {
        didSet { endPoint = CGPoint(x: endPointX, y: endPointY) }
    }
    /// 结束点 Y 坐标（0-1）
    @IBInspectable public var endPointY: CGFloat = 1 {
        didSet { endPoint = CGPoint(x: endPointX, y: endPointY) }
    }
    
    /// 渐变起始点（默认左上角）
    public var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet { setNeedsLayout() }
    }
    
    /// 渐变结束点（默认右下角）
    public var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet { setNeedsLayout() }
    }
    
    private var gradientLayer: CAGradientLayer?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.removeFromSuperlayer()
        
        if isGradient {
            gradientLayer = CAGradientLayer()
            gradientLayer!.colors = [startColor.cgColor, endColor.cgColor]
            gradientLayer!.frame = bounds
            gradientLayer!.startPoint = startPoint
            gradientLayer!.endPoint = endPoint
            layer.insertSublayer(gradientLayer!, at: 0)
        }
    }
    
    public func setGradient(startColor: UIColor, endColor: UIColor, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        self.startColor = startColor
        self.endColor = endColor
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.isGradient = true
        setNeedsLayout()
    }
}