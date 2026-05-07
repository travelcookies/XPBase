import UIKit

/// 虚线边框视图（XP命名空间版本）
/// 支持在 Interface Builder 中可视化配置虚线边框样式
///
/// 使用示例：
/// ```swift
/// // 创建虚线边框视图
/// let dashedView = XPDashedBorderView()
/// dashedView.borderColor = .red
/// dashedView.borderWidth = 2
/// dashedView.dashWidth = 5
/// dashedView.dashGap = 3
/// dashedView.cornerRadius = 8
/// view.addSubview(dashedView)
/// 
/// // 或者使用链式方法设置
/// dashedView.setBorder(color: .blue, width: 1, dashWidth: 10, dashGap: 5, cornerRadius: 4)
/// ```
@IBDesignable
public class XPDashedBorderView: UIView {
    /// 边框颜色（默认黑色）
    @IBInspectable public var borderColor: UIColor = .black {
        didSet { updateBorder() }
    }
    
    /// 边框宽度（默认2）
    @IBInspectable public var borderWidth: CGFloat = 2 {
        didSet { updateBorder() }
    }
    
    /// 虚线线段宽度（默认5）
    @IBInspectable public var dashWidth: CGFloat = 5 {
        didSet { updateBorder() }
    }
    
    /// 虚线间隔宽度（默认3）
    @IBInspectable public var dashGap: CGFloat = 3 {
        didSet { updateBorder() }
    }
    
    /// 圆角半径（默认0）
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet { updateBorder() }
    }
    
    private var borderLayer: CAShapeLayer?
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateBorder()
    }
    
    private func updateBorder() {
        borderLayer?.removeFromSuperlayer()
        
        let layer = CAShapeLayer()
        layer.strokeColor = borderColor.cgColor
        layer.lineDashPattern = [dashWidth as NSNumber, dashGap as NSNumber]
        layer.frame = bounds
        layer.fillColor = nil
        layer.lineWidth = borderWidth
        layer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(layer)
        borderLayer = layer
    }
    
    public func setBorder(color: UIColor, width: CGFloat, dashWidth: CGFloat, dashGap: CGFloat, cornerRadius: CGFloat) {
        self.borderColor = color
        self.borderWidth = width
        self.dashWidth = dashWidth
        self.dashGap = dashGap
        self.cornerRadius = cornerRadius
    }
}