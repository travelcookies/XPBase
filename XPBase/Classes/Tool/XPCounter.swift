import UIKit

/// 数字动画计数器
/// 使用 CADisplayLink 实现流畅的数值变化动画，支持缓动效果
/// 
/// 使用示例：
/// ```swift
/// // 数字从 0 到 100 的动画，持续 2 秒
/// XPCounter.animate(from: 0, to: 100, duration: 2) { value in
///     label.text = String(format: "%.0f", value)
/// } completion: {
///     print("动画完成")
/// }
/// ```
public class XPCounter: NSObject {
    /// 动画完成回调
    public typealias Completion = () -> Void
    
    private var displayLink: CADisplayLink?
    private var fromValue: CGFloat = 0
    private var toValue: CGFloat = 0
    private var currentValue: CGFloat = 0
    private var duration: TimeInterval = 0
    private var startTime: TimeInterval = 0
    private var updateBlock: ((CGFloat) -> Void)?
    private var completion: Completion?
    
    /// 执行数字动画
    /// - Parameters:
    ///   - from: 起始值
    ///   - to: 目标值
    ///   - duration: 动画时长（秒）
    ///   - update: 每帧更新回调，返回当前值
    ///   - completion: 动画完成回调（可选）
    public class func animate(from: CGFloat,
                              to: CGFloat,
                              duration: TimeInterval,
                              update: @escaping (CGFloat) -> Void,
                              completion: Completion? = nil) {
        let counter = XPCounter()
        counter.fromValue = from
        counter.toValue = to
        counter.duration = duration
        counter.updateBlock = update
        counter.completion = completion
        counter.start()
    }
    
    private func start() {
        currentValue = fromValue
        startTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func update() {
        let elapsed = CACurrentMediaTime() - startTime
        
        if elapsed >= duration {
            currentValue = toValue
            updateBlock?(currentValue)
            displayLink?.invalidate()
            displayLink = nil
            completion?()
            return
        }
        
        let progress = elapsed / duration
        let easeProgress = 1 - pow(1 - progress, 3)
        currentValue = fromValue + (toValue - fromValue) * CGFloat(easeProgress)
        
        updateBlock?(currentValue)
    }
}