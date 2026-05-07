import UIKit

/// 带下划线的按钮（XP命名空间版本）
/// 继承自 UIButton，底部带有下划线视图，常用于选项卡切换场景
///
/// 使用示例：
/// ```swift
/// // 创建下划线按钮
/// let button = XPUnderlineButton()
/// button.setTitle("选项1", for: .normal)
/// button.setTitleColor(.black, for: .normal)
/// button.underlineColor = .systemBlue
/// button.underlineHeight = 3
/// view.addSubview(button)
/// 
/// // 设置下划线宽度（默认与按钮等宽）
/// button.underlineWidth = 50
/// 
/// // 通过选中状态控制下划线显示
/// button.isSelected = true // 显示下划线
/// button.isSelected = false // 隐藏下划线
/// ```
public class XPUnderlineButton: UIButton {
    /// 下划线视图
    public let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        return v
    }()
    
    /// 下划线宽度（nil 表示与按钮等宽）
    public var underlineWidth: CGFloat? {
        didSet {
            if let width = underlineWidth {
                underlineView.snp.remakeConstraints { make in
                    make.bottom.centerX.equalToSuperview()
                    make.width.equalTo(width)
                    make.height.equalTo(3)
                }
            }
        }
    }
    
    public var underlineColor: UIColor = .systemBlue {
        didSet {
            underlineView.backgroundColor = underlineColor
        }
    }
    
    public var underlineHeight: CGFloat = 3 {
        didSet {
            underlineView.snp.remakeConstraints { make in
                make.bottom.centerX.equalToSuperview()
                if let width = underlineWidth {
                    make.width.equalTo(width)
                } else {
                    make.left.right.equalToSuperview()
                }
                make.height.equalTo(underlineHeight)
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(underlineHeight)
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            underlineView.isHidden = !isSelected
        }
    }
}