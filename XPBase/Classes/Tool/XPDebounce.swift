import Foundation

/// 防抖工具类（XP命名空间版本）
/// 提供线程安全的防抖功能，在指定时间内多次调用只执行最后一次
///
/// 使用示例：
/// ```swift
/// // 使用共享实例执行防抖操作
/// XPDebounce.shared.execute(id: "search", delay: 0.5) {
///     print("执行搜索")
/// }
/// 
/// // 使用 DispatchQueue 扩展方法
/// DispatchQueue.main.debounce(id: "textInput", delay: 0.3) {
///     print("文本输入完成")
/// }
/// 
/// // 取消待执行的防抖操作
/// XPDebounce.shared.cancel(id: "search")
/// 
/// // 检查是否有待执行的防抖操作
/// let isPending = XPDebounce.shared.isPending(id: "search")
/// ```
public class XPDebounce {
    private var workItems: [AnyHashable: DispatchWorkItem] = [:]
    private let lock = NSRecursiveLock()
    
    public static let shared = XPDebounce()
    
    /// 执行防抖操作
    /// - Parameters:
    ///   - id: 操作唯一标识
    ///   - delay: 延迟时间（秒）
    ///   - action: 延迟后执行的闭包
    public func execute(
        id: AnyHashable,
        delay: TimeInterval,
        action: @escaping () -> Void
    ) {
        lock.lock()
        cancel(id: id)
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.lock.lock()
            self?.workItems.removeValue(forKey: id)
            self?.lock.unlock()
            action()
        }
        
        workItems[id] = workItem
        lock.unlock()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
    
    /// 取消待执行的防抖操作
    /// - Parameter id: 操作唯一标识
    public func cancel(id: AnyHashable) {
        lock.lock()
        workItems[id]?.cancel()
        workItems.removeValue(forKey: id)
        lock.unlock()
    }
    
    /// 检查是否有待执行的防抖操作
    /// - Parameter id: 操作唯一标识
    /// - Returns: 是否有待执行的操作
    public func isPending(id: AnyHashable) -> Bool {
        lock.lock()
        let exists = workItems[id] != nil
        lock.unlock()
        return exists
    }
}

public extension DispatchQueue {
    /// DispatchQueue 防抖扩展方法
    /// - Parameters:
    ///   - id: 操作唯一标识
    ///   - delay: 延迟时间（秒）
    ///   - work: 延迟后执行的闭包
    func debounce(
        id: AnyHashable,
        delay: TimeInterval,
        execute work: @escaping @convention(block) () -> Void
    ) {
        XPDebounce.shared.execute(id: id, delay: delay, action: work)
    }
}