import Foundation

public typealias XPAsyncTask = () -> Void
public typealias XPCancellableTask = (_ cancel: Bool) -> Void

/// 异步任务调度工具（XP命名空间版本）
/// 提供便捷的异步任务调度方法，包括延迟执行、主线程执行、全局队列执行等
///
/// 使用示例：
/// ```swift
/// // 延迟执行任务（可取消）
/// let task = XPAsync.delay(2.0) {
///     print("延迟2秒后执行")
/// }
/// // 取消任务
/// XPAsync.cancel(task)
/// 
/// // 在主线程执行任务
/// XPAsync.asyncMain {
///     // 更新UI操作
///     label.text = "更新完成"
/// }
/// 
/// // 在全局队列执行任务
/// XPAsync.asyncGlobal {
///     // 耗时操作
///     let result = performHeavyTask()
///     // 完成后回到主线程
///     XPAsync.asyncMain {
///         updateUI(with: result)
///     }
/// }
/// 
/// // 指定QoS级别执行任务
/// XPAsync.asyncGlobal(qos: .background) {
///     // 后台任务
/// }
/// 
/// // 延迟后在主线程执行
/// XPAsync.asyncAfterMain(1.5) {
///     print("延迟1.5秒后在主线程执行")
/// }
/// 
/// // 异步执行任务（返回可取消的work item）
/// let workItem = XPAsync.async {
///     // 后台任务
/// }
/// workItem.cancel()
/// 
/// // 异步执行任务，完成后在主线程执行回调
/// XPAsync.async({
///     // 后台任务
///     return fetchData()
/// }, {
///     // 主线程回调
///     updateUI()
/// })
/// 
/// // 延迟后异步执行任务
/// let delayedWork = XPAsync.asyncDelay(3.0) {
///     print("延迟3秒后执行")
/// }
/// ```
public struct XPAsync {
    @discardableResult
    public static func delay(_ time: TimeInterval, task: @escaping XPAsyncTask) -> XPCancellableTask? {
        func dispatchLater(block: @escaping XPCancellableTask) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t) {
                block(false)
            }
        }
        
        var closure: XPAsyncTask? = task
        var result: XPCancellableTask?
        
        let delayedClosure: XPCancellableTask = { cancel in
            if let closure = closure {
                if !cancel {
                    DispatchQueue.main.async(execute: closure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatchLater { _ in
            if let result = result {
                result(false)
            }
        }
        
        return result
    }
    
    public static func cancel(_ task: XPCancellableTask?) {
        task?(true)
    }
    
    public static func asyncMain(_ task: @escaping XPAsyncTask) {
        DispatchQueue.main.async {
            task()
        }
    }
    
    public static func asyncGlobal(_ task: @escaping XPAsyncTask) {
        DispatchQueue.global().async {
            task()
        }
    }
    
    public static func asyncGlobal(qos: DispatchQoS.QoSClass, _ task: @escaping XPAsyncTask) {
        DispatchQueue.global(qos: qos).async {
            task()
        }
    }
    
    public static func asyncAfterMain(_ delay: TimeInterval, _ task: @escaping XPAsyncTask) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            task()
        }
    }
    
    @discardableResult
    public static func async(_ task: @escaping XPAsyncTask) -> DispatchWorkItem {
        return _async(task)
    }
    
    @discardableResult
    public static func async(_ task: @escaping XPAsyncTask, _ mainTask: @escaping XPAsyncTask) -> DispatchWorkItem {
        return _async(task, mainTask)
    }
    
    private static func _async(_ task: @escaping XPAsyncTask, _ mainTask: XPAsyncTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
    
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping XPAsyncTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }
    
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping XPAsyncTask, _ mainTask: @escaping XPAsyncTask) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }
    
    private static func _asyncDelay(_ seconds: Double, _ task: @escaping XPAsyncTask, _ mainTask: XPAsyncTask? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        
        return item
    }
}