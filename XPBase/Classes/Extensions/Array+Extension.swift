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
/// let uniqueUsers = users.xp.deduplicate { $0.id } // 根据id去重
/// 
/// // 安全访问数组元素（避免越界）
/// let value = array.xp.safeGet(5) // nil（数组越界）
/// let value = array.xp.safeGet(0) // Optional(1)
/// 
/// // 获取第一个元素（安全）
/// let first = array.xp.firstOrNil
/// 
/// // 获取最后一个元素（安全）
/// let last = array.xp.lastOrNil
/// 
/// // 检查数组是否为空
/// let isEmpty = array.xp.isEmptyOrNil
/// ```
extension Array: XPCompatible {}

public extension XP where Base: RangeReplaceableCollection, Base.Element: Equatable {
    /// 去重（元素需遵循 Equatable）
    /// - Returns: 去重后的数组
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

public extension XP where Base: Collection {
    /// 根据闭包规则去重
    /// - Parameter filter: 用于生成比较key的闭包
    /// - Returns: 去重后的数组
    func deduplicate<E: Equatable>(filter: (Base.Element) -> E) -> [Base.Element] {
        var ret: [Base.Element] = []
        for value in base {
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
    func safeGet(_ index: Int) -> Base.Element? {
        guard index >= 0, index < base.count else {
            return nil
        }
        let idx = base.index(base.startIndex, offsetBy: index)
        return base[idx]
    }
    
    /// 安全获取第一个元素
    /// - Returns: 第一个元素（数组为空时返回 nil）
    var firstOrNil: Base.Element? {
        return base.first
    }
    
    /// 检查数组是否为空或 nil
    /// - Returns: 是否为空
    var isEmptyOrNil: Bool {
        return base.isEmpty
    }
    
    /// 安全获取元素数量
    /// - Returns: 元素数量
    var countSafe: Int {
        return base.count
    }
    
    /// 安全检查索引是否有效
    /// - Parameter index: 索引
    /// - Returns: 索引是否有效
    func isValidIndex(_ index: Int) -> Bool {
        return index >= 0 && index < base.count
    }
}

public extension XP where Base: BidirectionalCollection {
    /// 安全获取最后一个元素
    /// - Returns: 最后一个元素（数组为空时返回 nil）
    var lastOrNil: Base.Element? {
        return base.last
    }
}
