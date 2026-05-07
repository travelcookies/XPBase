import Foundation

/// 数组扩展（支持XP命名空间）
/// 提供数组去重和安全访问等便捷方法
///
/// 使用示例：
/// ```swift
/// // 使用 XP 命名空间去重（元素需遵循 Equatable）
/// let array = [1, 2, 2, 3, 3, 3]
/// let uniqueArray = array.xp.deduplicated() // [1, 2, 3]
/// 
/// // 使用闭包去重（自定义比较规则）
/// let users = [User(id: 1, name: "A"), User(id: 2, name: "B"), User(id: 1, name: "A")]
/// let uniqueUsers = users.deduplicate { $0.id } // 根据id去重
/// 
/// // 安全访问数组元素（避免越界）
/// let value = array.safeGet(5) // nil（数组越界）
/// let value = array.safeGet(0) // Optional(1)
/// ```
extension Array: XPCompatible {}

public extension XP where Base: RangeReplaceableCollection, Base.Element: Equatable {
    /// 去重（元素需遵循 Equatable）
    func deduplicated() -> [Base.Element] {
        var result: [Base.Element] = []
        for element in base {
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}

public extension Array {
    /// 根据闭包规则去重
    /// - Parameter filter: 用于生成比较key的闭包
    /// - Returns: 去重后的数组
    func deduplicate<E: Equatable>(filter: (Element) -> E) -> [Element] {
        var ret = [Element]()
        for value in self {
            let key = filter(value)
            if !ret.map({ filter($0) }).contains(key) {
                ret.append(value)
            }
        }
        return ret
    }
    
    /// 安全访问数组元素（避免越界）
    /// - Parameter index: 索引
    /// - Returns: 元素（越界时返回 nil）
    func safeGet(_ index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[index]
    }
}