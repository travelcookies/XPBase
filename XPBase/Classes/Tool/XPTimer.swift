import Foundation

/// 定时器管理类（XP命名空间版本）
/// 提供线程安全的定时器管理功能，支持通过ID管理多个定时器
///
/// 使用示例：
/// ```swift
/// // 创建重复定时器
/// XPTimer.shared.schedule(id: "myTimer", interval: 1.0) { date in
///     print("定时器触发: \(date)")
/// }
/// 
/// // 创建一次性定时器（repeats: false）
/// XPTimer.shared.schedule(id: "singleTimer", interval: 5.0, repeats: false) { _ in
///     print("一次性定时器触发")
/// }
/// 
/// // 创建定时器（不带Date参数）
/// XPTimer.shared.schedule(id: "simpleTimer", interval: 2.0) {
///     print("定时器触发")
/// }
/// 
/// // 检查定时器是否有效
/// let isValid = XPTimer.shared.isValid(id: "myTimer")
/// 
/// // 手动触发定时器
/// XPTimer.shared.fire(id: "myTimer")
/// 
/// // 取消指定定时器
/// XPTimer.shared.cancel(id: "myTimer")
/// 
/// // 取消所有定时器
/// XPTimer.shared.invalidateAll()
/// ```
public class XPTimer {
    private var timers: [AnyHashable: Timer] = [:]
    private let lock = NSRecursiveLock()
    
    public static let shared = XPTimer()
    
    /// 调度定时器
    /// - Parameters:
    ///   - id: 定时器唯一标识
    ///   - interval: 时间间隔（秒）
    ///   - repeats: 是否重复执行（默认 true）
    ///   - tolerance: 容差时间（可选）
    ///   - action: 定时器触发时执行的闭包，参数为触发时间
    /// - Returns: 创建的定时器
    @discardableResult
    public func schedule(
        id: AnyHashable,
        interval: TimeInterval,
        repeats: Bool = true,
        tolerance: TimeInterval? = nil,
        action: @escaping (Date) -> Void
    ) -> Timer {
        lock.lock()
        cancel(id: id)
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats) { timer in
            action(Date())
        }
        
        if let tolerance = tolerance {
            timer.tolerance = tolerance
        }
        
        timers[id] = timer
        lock.unlock()
        
        return timer
    }
    
    /// 调度定时器（简化版，不带Date参数）
    /// - Parameters:
    ///   - id: 定时器唯一标识
    ///   - interval: 时间间隔（秒）
    ///   - repeats: 是否重复执行（默认 true）
    ///   - tolerance: 容差时间（可选）
    ///   - action: 定时器触发时执行的闭包
    /// - Returns: 创建的定时器
    @discardableResult
    public func schedule(
        id: AnyHashable,
        interval: TimeInterval,
        repeats: Bool = true,
        tolerance: TimeInterval? = nil,
        action: @escaping () -> Void
    ) -> Timer {
        return schedule(id: id, interval: interval, repeats: repeats, tolerance: tolerance) { _ in
            action()
        }
    }
    
    /// 取消指定ID的定时器
    /// - Parameter id: 定时器唯一标识
    public func cancel(id: AnyHashable) {
        lock.lock()
        timers[id]?.invalidate()
        timers.removeValue(forKey: id)
        lock.unlock()
    }
    
    /// 检查指定ID的定时器是否有效
    /// - Parameter id: 定时器唯一标识
    /// - Returns: 定时器是否有效
    public func isValid(id: AnyHashable) -> Bool {
        lock.lock()
        let valid = timers[id]?.isValid ?? false
        lock.unlock()
        return valid
    }
    
    /// 手动触发指定ID的定时器
    /// - Parameter id: 定时器唯一标识
    public func fire(id: AnyHashable) {
        lock.lock()
        timers[id]?.fire()
        lock.unlock()
    }
    
    /// 取消所有定时器
    public func invalidateAll() {
        lock.lock()
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        lock.unlock()
    }
}