# Extensions 模块

## Array+Extension

**功能说明**：数组扩展，提供数组去重和安全访问等便捷方法。

**使用示例**：
```swift
// 使用 XP 命名空间去重（元素需遵循 Equatable）
let array = [1, 2, 2, 3, 3, 3]
let uniqueArray = array.xp.deduplicated() // [1, 2, 3]

// 使用闭包去重（自定义比较规则）
let users = [User(id: 1, name: "A"), User(id: 2, name: "B"), User(id: 1, name: "A")]
let uniqueUsers = users.deduplicate { $0.id } // 根据id去重

// 安全访问数组元素（避免越界）
let value = array.safeGet(5) // nil（数组越界）
let value = array.safeGet(0) // Optional(1)
```

---

## String+Extension

**功能说明**：字符串扩展，提供常用的字符串操作方法。

**使用示例**：
```swift
// 检查是否为空
let isEmpty = "".isEmptyOrWhitespace

// 移除首尾空格
let trimmed = "  hello  ".trimmed

// 检查是否包含子字符串（忽略大小写）
let contains = "Hello World".containsIgnoreCase("world")

// URL编码
let encoded = "hello world".urlEncoded

// URL解码
let decoded = "hello%20world".urlDecoded

// 转换为日期
let date = "2021-05-03".toDate()

// 格式化日期字符串
let formatted = Date().toString(format: "yyyy-MM-dd HH:mm:ss")
```

---

## Date+Extension

**功能说明**：日期扩展，提供常用的日期操作方法。

**使用示例**：
```swift
// 获取今天开始时间
let todayStart = Date().startOfDay

// 获取今天结束时间
let todayEnd = Date().endOfDay

// 判断是否是今天
let isToday = someDate.isToday

// 判断是否是昨天
let isYesterday = someDate.isYesterday

// 判断是否是本周
let isThisWeek = someDate.isThisWeek

// 获取星期几
let weekday = someDate.weekdayString

// 添加天数
let tomorrow = Date().addingDays(1)

// 计算两个日期之间的天数
let daysBetween = Date().days(since: anotherDate)
```

---

## UIColor+Extension

**功能说明**：颜色扩展，提供便捷的颜色创建和操作方法。

**使用示例**：
```swift
// 十六进制字符串转颜色
let color = UIColor(hex: "#FF5733")
let colorNoHash = UIColor(hex: "FF5733")

// 十六进制整数转颜色
let colorInt = UIColor(hex: 0xFF5733)

// 创建带透明度的颜色
let transparentColor = UIColor(hex: "#FF5733", alpha: 0.5)

// 获取颜色的RGB值
let rgb = color.rgbComponents

// 颜色变亮
let lighter = color.lighter(by: 20)

// 颜色变暗
let darker = color.darker(by: 20)
```

---

## UIView+Extension

**功能说明**：视图扩展，提供常用的视图操作方法。

**使用示例**：
```swift
// 添加圆角
view.addCorner(radius: 8)

// 添加边框
view.addBorder(color: .gray, width: 1)

// 添加阴影
view.addShadow(color: .black, offset: CGSize(width: 0, height: 2), radius: 4)

// 设置渐变色背景
view.setGradient(startColor: .red, endColor: .orange)

// 获取视图所在的ViewController
let vc = view.parentViewController

// 移除所有子视图
view.removeAllSubviews()
```

---

## Codable+Extension

**功能说明**：提供基于 Swift Codable 协议的序列化/反序列化扩展，支持 JSON 字符串和字典的相互转换。

**使用示例**：
```swift
// 定义遵循 HandyCodable 协议的模型
struct User: HandyCodable {
    var id: Int
    var name: String
    var email: String?
}

// 从 JSON 字符串解码
let jsonString = "{\"id\": 1, \"name\": \"John\", \"email\": \"john@example.com\"}"
if let user = User.decode(from: jsonString) {
    print(user.name) // 输出 "John"
}

// 编码为 JSON 字符串
let user = User(id: 2, name: "Jane", email: "jane@example.com")
if let jsonString = user.encodeToJSONString(prettyPrint: true) {
    print(jsonString)
}

// 编码为 JSON 字典
if let jsonDict = user.encodeToJSON() {
    print(jsonDict)
}
```

---

## Int+Extension

**功能说明**：整数扩展，提供金额转换、时间格式化、颜色转换等便捷方法。

**使用示例**：
```swift
// 金额转换（分转元）
let amountInFen = 1234 // 12.34元
let amountStr = amountInFen.xp.fen2YuanDecimalFormatterValue() // "12.34"

// 时间格式化（秒转时分秒）
let seconds = 3661 // 1小时1分钟1秒
let timeStr = seconds.xp.timeToStringFormatterValue() // "1小时1分钟1秒"

// 整数转颜色
let colorInt = 0xFF0000 // 红色
let color = colorInt.xp.hex // UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let transparentColor = colorInt.xp.hexa(0.5) // 带透明度的红色
```

---

## UIAlertController+Extension

**功能说明**：UIAlertController 扩展，提供便捷的警告框创建和显示方法。

**使用示例**：
```swift
// 创建并显示简单警告框
let alert = UIAlertController.xp.alert(title: "提示", message: "操作成功", okAction: {
    print("用户点击了确定")
})
alert.xp.show(in: self)

// 创建并显示带取消按钮的警告框
let confirmAlert = UIAlertController.xp.alertWithCancel(
    title: "确认", 
    message: "确定要删除这个项目吗？", 
    okAction: {
        print("用户点击了确定，执行删除操作")
    }, 
    cancelAction: {
        print("用户点击了取消，取消删除操作")
    }
)
confirmAlert.xp.show(in: self)

// 创建并显示带输入框的警告框
let inputAlert = UIAlertController.xp.alertWithInput(
    title: "输入", 
    message: "请输入您的姓名", 
    placeholder: "请输入姓名", 
    okAction: { text in
        print("用户输入了：\(text)")
    }
)
inputAlert.xp.show(in: self)
```

---

## UIButton+Extension

**功能说明**：UIButton 扩展，提供图文混排布局功能。

**使用示例**：
```swift
// 设置按钮图文混排 - 内容居中-图上文下
button.xp.contentLayout(.centerImageTop, 8, periphery: 16)

// 设置按钮图文混排 - 内容居中-图左文右（默认）
button.xp.contentLayout(.normal, 8, periphery: 16)

// 设置按钮图文混排 - 内容居左-图左文右
button.xp.contentLayout(.leftImageLeft, 8, periphery: 16)

// 设置按钮图文混排 - 内容居右-图右文左
button.xp.contentLayout(.rightImageRight, 8, periphery: 16)
```

**布局样式说明**：

| 样式 | 说明 |
|------|------|
| `.normal` | 内容居中，图左文右 |
| `.centerImageRight` | 内容居中，图右文左 |
| `.centerImageTop` | 内容居中，图上文下 |
| `.centerImageBottom` | 内容居中，图下文上 |
| `.leftImageLeft` | 内容居左，图左文右 |
| `.leftImageRight` | 内容居左，图右文左 |
| `.rightImageLeft` | 内容居右，图左文右 |
| `.rightImageRight` | 内容居右，图右文左 |

---

## UIImage+Extension

**功能说明**：UIImage 扩展，提供图片压缩、缩放和尺寸调整功能。

**使用示例**：
```swift
// 压缩图片到指定字节大小
let compressedImage = originalImage.xp.compressed(toByte: 1024 * 1024) // 压缩到1MB以内

// 按最大宽高缩放图片（保持比例）
let scaledImage = originalImage.xp.scaled(toMaxWidth: 1080, maxHeight: 1080)

// 调整图片到指定尺寸（可能拉伸）
let resizedImage = originalImage.xp.resize(to: CGSize(width: 200, height: 200))
```

---

## UITableView+Extension

**功能说明**：UITableView 扩展，提供分组列表圆角背景和边框样式设置功能。

**使用示例**：
```swift
// 简单设置圆角背景
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    tableView.xp.rTableView(willDisplay: cell, forRowAt: indexPath, 8.0, .white, dx: 16)
}

// 使用自定义外观设置
func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    var appearance = TableViewCellAppearance()
    appearance.cornerRadius = 10.0
    appearance.backgroundColor = .white
    appearance.strokeColor = .lightGray
    appearance.borderWidth = 1.0
    appearance.borderStyle = .dashed(pattern: [6, 4])
    tableView.xp.rTableView(willDisplay: cell, forRowAt: indexPath, appearance: appearance)
}
```

**TableViewCellAppearance 属性**：

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `cornerRadius` | CGFloat | 8.0 | 圆角半径 |
| `backgroundColor` | UIColor | .white | 背景颜色 |
| `strokeColor` | UIColor | .lightGray | 边框颜色 |
| `borderWidth` | CGFloat | 1.0 | 边框宽度 |
| `horizontalInset` | CGFloat | 15.0 | 水平边距 |
| `borderStyle` | BorderStyle | .solid | 边框样式（solid/dashed/dotted） |

---

## UITextField+Extension

**功能说明**：UITextField 扩展，提供输入框空白区域设置功能。

**使用示例**：
```swift
let textField = UITextField()

// 设置左边空白区域（使用默认尺寸）
textField.xp.setTextFieldNormalLeftV()

// 设置左边空白区域（自定义尺寸）
textField.xp.setTextFieldNormalLeftV(size: CGSize(width: 15, height: 30))
```

---

## XPCompatible

**功能说明**：XP 命名空间核心协议，用于为任意类型添加扩展方法，实现优雅的链式调用。

**使用示例**：
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

**命名空间优势**：

1. **避免命名冲突**：通过命名空间隔离，可以为不同类型添加同名方法而不会冲突
2. **代码组织**：将相关功能集中在一起，提高代码可读性
3. **类型安全**：通过泛型约束确保方法只对特定类型可用