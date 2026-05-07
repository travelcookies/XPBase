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
