import UIKit

/// 带下划线的文本输入框（XP命名空间版本）
/// 继承自 UITextField，底部带有下划线视图，常用于表单输入场景
///
/// 使用示例：
/// ```swift
/// // 创建下划线文本框
/// let textField = XPUnderlineTextField()
/// textField.placeholder = "请输入内容"
/// textField.underlineColor = .lightGray
/// textField.underlineHeight = 1
/// view.addSubview(textField)
/// 
/// // 修改下划线样式
/// textField.underlineColor = .systemBlue // 聚焦时改变颜色
/// ```
public class XPUnderlineTextField: UITextField {
    /// 下划线视图
    public let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        return v
    }()
    
    /// 下划线颜色（默认 systemBlue）
    public var underlineColor: UIColor = .systemBlue {
        didSet {
            underlineView.backgroundColor = underlineColor
        }
    }
    
    public var underlineHeight: CGFloat = 0.5 {
        didSet {
            underlineView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(underlineHeight)
                make.bottom.equalToSuperview()
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
            make.left.right.equalToSuperview()
            make.height.equalTo(underlineHeight)
            make.bottom.equalToSuperview()
        }
    }
}