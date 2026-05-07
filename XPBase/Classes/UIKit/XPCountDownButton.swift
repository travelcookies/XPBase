import UIKit

/// 倒计时按钮（XP命名空间版本）
/// 继承自 UIButton，支持倒计时功能，常用于发送验证码场景
///
/// 使用示例：
/// ```swift
/// // 创建倒计时按钮
/// let button = XPCountDownButton()
/// button.setTitle("发送验证码", for: .normal)
/// button.clickedBlock = { sender in
///     print("按钮被点击")
/// }
/// view.addSubview(button)
/// 
/// // 设置倒计时时间（默认300秒）
/// button.remainingSeconds = 60
/// 
/// // 自定义提示文字后缀
/// button.tipsPrefix = "秒后重新获取"
/// 
/// // 启动倒计时
/// button.startCountdown()
/// 
/// // 停止倒计时
/// button.stopCountdown()
/// ```
public class XPCountDownButton: UIButton {
    /// 按钮点击闭包
    public typealias ClickedClosure = (_ sender: UIButton) -> Void
    public var clickedBlock: ClickedClosure?
    
    private var countdownTimer: Timer?
    
    /// 是否正在倒计时
    public var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(updateTime(_:)),
                    userInfo: nil,
                    repeats: true
                )
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            self.isEnabled = !newValue
        }
    }
    
    /// 是否左对齐标题（默认居中）
    public var useLeftTitle = false {
        willSet {
            contentHorizontalAlignment = newValue ? .left : .center
        }
    }
    
    /// 倒计时提示文字后缀（默认 "s"）
    public var tipsPrefix: String = "s"
    
    /// 剩余秒数（默认300秒）
    public var remainingSeconds: Int = 300 {
        willSet {
            self.setTitle("\(newValue)\(tipsPrefix)", for: .normal)
            if newValue <= 0 {
                self.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        setTitle("发送验证码", for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addTarget(self, action: #selector(sendButtonClick(_:)), for: .touchUpInside)
    }
    
    @objc private func sendButtonClick(_ btn: UIButton) {
        self.isCounting = true
        self.remainingSeconds = 300
        clickedBlock?(btn)
    }
    
    @objc private func updateTime(_ btn: UIButton) {
        remainingSeconds -= 1
    }
    
    public func startCountdown(seconds: Int = 300) {
        self.isCounting = true
        self.remainingSeconds = seconds
    }
    
    public func stopCountdown() {
        self.isCounting = false
        self.remainingSeconds = 0
    }
    
    deinit {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
}