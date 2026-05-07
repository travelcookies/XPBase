import Foundation

/// 节流工具类（XP命名空间版本）
/// 提供线程安全的节流功能，在指定时间内多次调用只执行一次
///
/// 使用示例：
/// ```swift
/// // 使用共享实例执行节流操作（带值）
/// XPThrottle.shared.execute(id: "scroll", interval: 0.2, value: scrollOffset) { offset in
///     print("滚动位置: \(offset)")
/// }
/// 
/// // 使用共享实例执行节流操作（不带值，使用 latest: false 保留第一个值）
/// XPThrottle.shared.execute(id: "buttonClick", interval: 1.0, latest: false, value: ()) { _ in
///     print("按钮点击")
/// }
/// 
/// // 使用 DispatchQueue 扩展方法
/// DispatchQueue.main.throttle(id: "resize", interval: 0.1) {
///     print("窗口大小改变")
/// }
/// 
/// // 取消节流操作
/// XPThrottle.shared.cancel(id: "scroll")
/// ```
public class XPThrottle {
    private var throttleTimes: [AnyHashable: Date] = [:]
    private var throttleValues: [AnyHashable: Any] = [:]
    private let lock = NSRecursiveLock()
    
    public static let shared = XPThrottle()
    
    /// 执行节流操作
    /// - Parameters:
    ///   - id: 操作唯一标识
    ///   - interval: 节流时间间隔（秒）
    ///   - latest: 是否使用最新值（默认 true，设为 false 则保留第一个值）
    ///   - value: 传递给闭包的值
    ///   - action: 节流后执行的闭包
    public func execute<T>(
        id: AnyHashable,
        interval: TimeInterval,
        latest: Bool = true,
        value: T,
        action: @escaping (T) -> Void
    ) {
        lock.lock()
        let now = Date()
        
        guard let throttleTime = throttleTimes[id] else {
            throttleTimes[id] = now
            throttleValues[id] = nil
            lock.unlock()
            action(value)
            return
        }
        
        guard now.timeIntervalSince(throttleTime) < interval else {
            throttleTimes[id] = now
            throttleValues[id] = nil
            lock.unlock()
            action(value)
            return
        }
        
        let finalValue: T = latest ? value : (throttleValues[id] as? T ?? value)
        throttleValues[id] = finalValue
        
        let delay = throttleTime.addingTimeInterval(interval).timeIntervalSince(now)
        lock.unlock()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.lock.lock()
            if let storedValue = self?.throttleValues[id] as? T {
                self?.lock.unlock()
                action(storedValue)
            } else {
                self?.lock.unlock()
            }
            self?.lock.lock()
            self?.throttleTimes[id] = nil
            self?.throttleValues[id] = nil
            self?.lock.unlock()
        }
    }
    
    /// 取消节流操作
    /// - Parameter id: 操作唯一标识
    public func cancel(id: AnyHashable) {
        lock.lock()
        throttleTimes.removeValue(forKey: id)
        throttleValues.removeValue(forKey: id)
        lock.unlock()
    }
}

public extension DispatchQueue {
    /// DispatchQueue 节流扩展方法
    /// - Parameters:
    ///   - id: 操作唯一标识
    ///   - interval: 节流时间间隔（秒）
    ///   - latest: 是否使用最新值（默认 true）
    ///   - work: 节流后执行的闭包
    func throttle(
        id: AnyHashable,
        interval: TimeInterval,
        latest: Bool = true,
        execute work: @escaping @convention(block) () -> Void
    ) {
        XPThrottle.shared.execute(id: id, interval: interval, latest: latest, value: ()) { _ in
            work()
        }
    }
}