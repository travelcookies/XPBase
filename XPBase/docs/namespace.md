# 命名空间说明

XPBase 使用 `XP<Base>` 结构体实现命名空间模式，通过扩展 `XPCompatible` 协议为任意类型添加扩展方法。

## 实现原理

```swift
// 让类型遵循 XPCompatible 协议
extension UIView: XPCompatible {}

// 在扩展中使用 XP 命名空间添加方法
public extension XP where Base == UIView {
    func addCorner(radius: CGFloat) {
        base.layer.cornerRadius = radius
        base.clipsToBounds = true
    }
}

// 使用扩展方法
let view = UIView()
view.xp.addCorner(radius: 8)
```

## 命名空间优势

1. **避免命名冲突**：通过命名空间隔离，可以为不同类型添加同名方法而不会冲突
2. **代码组织**：将相关功能集中在一起，提高代码可读性
3. **类型安全**：通过泛型约束确保方法只对特定类型可用

## 使用模式

```swift
// 基础模式
someObject.xp.someMethod()

// 链式调用
view.xp.addCorner(radius: 8)
     .xp.addBorder(color: .gray, width: 1)

// 静态方法
String.xp.someStaticMethod()
```
