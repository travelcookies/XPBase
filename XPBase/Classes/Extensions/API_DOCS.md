# XPBase API 文档

本文档汇总了 XPBase 框架中所有工具类和扩展的功能说明及使用示例。

---

## 目录

- [UIKit 模块](#uikit-模块)
  - [XPScreen](#xpscreen)
  - [XPDevice](#xpdevice)
  - [XPColor](#xpcolor)
  - [XPFont](#xpfont)
  - [XPUnderlineButton](#xpunderlinebutton)
  - [XPUnderlineTextField](#xpunderlinetextfield)
  - [XPCountDownButton](#xpcountdownbutton)
  - [XPDashedBorderView](#xpdashedborderview)
  - [XPGradientButton](#xpgradientbutton)
  - [XPGradientView](#xpgradientview)
- [Tool 模块](#tool-模块)
  - [XPTimer](#xptimer)
  - [XPDebounce](#xpdebounce)
  - [XPThrottle](#xpthrottle)
  - [XPAppInfo](#xpappinfo)
  - [XPImage](#xpimage)
  - [XPAnimation](#xpanimation)
  - [XPTime](#xptime)
  - [XPAsync](#xpasync)
  - [XPLanguageManager](#xplanguagemanager)
- [Extensions 模块](#extensions-模块)
  - [Array+Extension](#arrayextension)
  - [String+Extension](#stringextension)
  - [Date+Extension](#dateextension)
  - [UIColor+Extension](#uicolorextension)
  - [UIView+Extension](#uiviewextension)
- [Network 模块](#network-模块)
  - [XPNetworkLoggerPlugin](#xpnetworkloggerplugin)
  - [XPBaseModel](#xpbasemodel)
  - [XPReachableManager](#xpreachablemanager)
- [Log 模块](#log-模块)
  - [XPLogger](#xplogger)
- [Navigator 模块](#navigator-模块)
  - [XPNavigator](#xpnavigator)
- [MediaPicker 模块](#mediapicker-模块)
  - [XPMediaPickerTool](#xpmediapickertool)
- [WebView 模块](#webview-模块)
  - [XPWebPageController](#xpwebpagecontroller)
- [Toast 模块](#toast-模块)
  - [XPToast](#xptoast)
- [命名空间说明](#命名空间说明)
- [总结](#总结)

---

## UIKit 模块

### XPScreen
**功能说明**：屏幕信息工具类，提供全面的屏幕尺寸、设备类型、安全区域等信息，支持各种 iPhone/iPad 设备的适配。

**使用示例**：
```swift
// 获取屏幕尺寸
let screenWidth = XPScreen.width
let screenHeight = XPScreen.height

// 获取设备类型信息
let deviceModel = XPScreen.deviceModel // 设备型号标识符
let deviceName = XPScreen.deviceName   // 设备名称（如 "iPhone 15 Pro"）

// 判断设备类型
let isIPhone = XPScreen.isIPhone
let isIPad = XPScreen.isIPad
let isSimulator = XPScreen.isSimulator

// 判断屏幕类型
let isNotchedScreen = XPScreen.isNotchedScreen   // 是否有刘海/灵动岛
let isDynamicIslandScreen = XPScreen.isDynamicIslandScreen  // 是否灵动岛屏幕
let isFullScreen = XPScreen.isFullScreen   // 是否全屏设备

// 获取安全区域
let safeAreaInsets = XPScreen.safeAreaInsets
let safeBottom = XPScreen.safeAreaBottom
let safeTop = XPScreen.safeAreaTop

// 获取导航栏和状态栏高度
let navBarHeight = XPScreen.navBarHeight
let navBarFullHeight = XPScreen.navBarFullHeight
let statusBarHeight = XPScreen.statusBarFullHeight

// 获取TabBar高度
let tabBarHeight = XPScreen.tabBarHeight
```

---

### XPDevice
**功能说明**：设备信息工具类，提供设备相关信息的获取方法，包括设备型号、系统版本、应用信息等。

**使用示例**：
```swift
// 获取设备名称
let deviceName = XPDevice.share.name // 如 "iPhone 13"

// 获取设备显示名称
let displayName = XPDevice.share.deviceName // 如 "张三的 iPhone"

// 获取系统名称
let systemName = XPDevice.share.sysName // "iOS"

// 获取系统版本
let systemVersion = XPDevice.share.sysVersion // "15.0"

// 获取设备UUID
let uuid = XPDevice.share.deviceUUID

// 获取设备型号
let model = XPDevice.share.deviceModel // "iPhone"

// 获取应用版本号
let appVersion = XPDevice.share.appVersion // "1.0.0"

// 获取应用构建版本
let buildVersion = XPDevice.share.appBuildVersion // "1"

// 获取应用名称
let appName = XPDevice.share.appName // "MyApp"
```

---

### XPColor
**功能说明**：颜色工具类，提供便捷的颜色创建方法，支持 RGB、十六进制整数、十六进制字符串等多种方式。

**使用示例**：
```swift
// 使用RGB值创建颜色（不透明）
let redColor = XPColor.rgb(r: 255, g: 0, b: 0)

// 使用RGB值创建颜色（带透明度）
let transparentRed = XPColor.rgba(r: 255, g: 0, b: 0, a: 0.5)

// 使用十六进制整数创建颜色（不透明）
let blueColor = XPColor.hex(hexValue: 0x0000FF)

// 使用十六进制整数创建颜色（带透明度）
let transparentBlue = XPColor.hexa(hexValue: 0x0000FF, a: 0.5)

// 使用十六进制字符串创建颜色（不透明）
let greenColor = XPColor.hex("#00FF00")
let greenColorNoHash = XPColor.hex("00FF00") // 不带#号也可以

// 使用十六进制字符串创建颜色（带透明度）
let transparentGreen = XPColor.hexa("#00FF00", alpha: 0.5)
```

---

### XPFont
**功能说明**：字体工具类，提供便捷的字体创建方法。

**使用示例**：
```swift
// 创建系统字体（常规字重）
let font = XPFont.font(16)

// 创建指定字重的系统字体
let mediumFont = XPFont.font(16, .medium)
let boldFont = XPFont.font(18, .bold)

// 创建粗体字体
let boldTextFont = XPFont.bold(16)

// 创建斜体字体
let italicFont = XPFont.italic(16)
```

---

### XPUnderlineButton
**功能说明**：带下划线的按钮，继承自 UIButton，底部带有下划线视图，常用于选项卡切换场景。

**使用示例**：
```swift
// 创建下划线按钮
let button = XPUnderlineButton()
button.setTitle("选项1", for: .normal)
button.setTitleColor(.black, for: .normal)
button.underlineColor = .systemBlue
button.underlineHeight = 3
view.addSubview(button)

// 设置下划线宽度（默认与按钮等宽）
button.underlineWidth = 50

// 通过选中状态控制下划线显示
button.isSelected = true // 显示下划线
button.isSelected = false // 隐藏下划线
```

---

### XPUnderlineTextField
**功能说明**：带下划线的文本输入框，继承自 UITextField，底部带有下划线视图，常用于表单输入场景。

**使用示例**：
```swift
// 创建下划线文本框
let textField = XPUnderlineTextField()
textField.placeholder = "请输入内容"
textField.underlineColor = .lightGray
textField.underlineHeight = 1
view.addSubview(textField)

// 修改下划线样式
textField.underlineColor = .systemBlue // 聚焦时改变颜色
```

---

### XPCountDownButton
**功能说明**：倒计时按钮，继承自 UIButton，支持倒计时功能，常用于发送验证码场景。

**使用示例**：
```swift
// 创建倒计时按钮
let button = XPCountDownButton()
button.setTitle("发送验证码", for: .normal)
button.clickedBlock = { sender in
    print("按钮被点击")
}
view.addSubview(button)

// 设置倒计时时间（默认300秒）
button.remainingSeconds = 60

// 自定义提示文字后缀
button.tipsPrefix = "秒后重新获取"

// 启动倒计时
button.startCountdown()

// 停止倒计时
button.stopCountdown()
```

---

### XPDashedBorderView
**功能说明**：虚线边框视图，支持在 Interface Builder 中可视化配置虚线边框样式。

**使用示例**：
```swift
// 创建虚线边框视图
let dashedView = XPDashedBorderView()
dashedView.borderColor = .red
dashedView.borderWidth = 2
dashedView.dashWidth = 5
dashedView.dashGap = 3
dashedView.cornerRadius = 8
view.addSubview(dashedView)

// 或者使用链式方法设置
dashedView.setBorder(color: .blue, width: 1, dashWidth: 10, dashGap: 5, cornerRadius: 4)
```

---

### XPGradientButton
**功能说明**：渐变背景按钮，继承自 UIButton，支持渐变背景色，支持在 Interface Builder 中可视化配置。

**使用示例**：
```swift
// 创建渐变按钮
let button = XPGradientButton()
button.setTitle("提交", for: .normal)
button.setTitleColor(.white, for: .normal)
button.setGradient(startColor: .red, endColor: .orange)
view.addSubview(button)

// 自定义渐变方向（从右上到左下）
button.setGradient(startColor: .blue, endColor: .purple, 
                  startPoint: CGPoint(x: 1, y: 0), 
                  endPoint: CGPoint(x: 0, y: 1))
```

---

### XPGradientView
**功能说明**：渐变背景视图，继承自 UIView，支持渐变背景色，支持在 Interface Builder 中可视化配置。

**使用示例**：
```swift
// 创建渐变视图
let gradientView = XPGradientView()
gradientView.setGradient(startColor: .red, endColor: .orange)
view.addSubview(gradientView)

// 自定义渐变方向（从右上到左下）
gradientView.setGradient(startColor: .blue, endColor: .purple, 
                        startPoint: CGPoint(x: 1, y: 0), 
                        endPoint: CGPoint(x: 0, y: 1))
```

---

## Tool 模块

### XPTimer
**功能说明**：定时器管理类，提供线程安全的定时器管理功能，支持通过 ID 管理多个定时器。

**使用示例**：
```swift
// 创建重复定时器
XPTimer.shared.schedule(id: "myTimer", interval: 1.0) { date in
    print("定时器触发: \(date)")
}

// 创建一次性定时器（repeats: false）
XPTimer.shared.schedule(id: "singleTimer", interval: 5.0, repeats: false) { _ in
    print("一次性定时器触发")
}

// 创建定时器（不带Date参数）
XPTimer.shared.schedule(id: "simpleTimer", interval: 2.0) {
    print("定时器触发")
}

// 检查定时器是否有效
let isValid = XPTimer.shared.isValid(id: "myTimer")

// 手动触发定时器
XPTimer.shared.fire(id: "myTimer")

// 取消指定定时器
XPTimer.shared.cancel(id: "myTimer")

// 取消所有定时器
XPTimer.shared.invalidateAll()
```

---

### XPDebounce
**功能说明**：防抖工具类，提供线程安全的防抖功能，在指定时间内多次调用只执行最后一次。

**使用示例**：
```swift
// 使用共享实例执行防抖操作
XPDebounce.shared.execute(id: "search", delay: 0.5) {
    print("执行搜索")
}

// 使用 DispatchQueue 扩展方法
DispatchQueue.main.debounce(id: "textInput", delay: 0.3) {
    print("文本输入完成")
}

// 取消待执行的防抖操作
XPDebounce.shared.cancel(id: "search")

// 检查是否有待执行的防抖操作
let isPending = XPDebounce.shared.isPending(id: "search")
```

---

### XPThrottle
**功能说明**：节流工具类，提供线程安全的节流功能，在指定时间内多次调用只执行一次。

**使用示例**：
```swift
// 使用共享实例执行节流操作（带值）
XPThrottle.shared.execute(id: "scroll", interval: 0.2, value: scrollOffset) { offset in
    print("滚动位置: \(offset)")
}

// 使用共享实例执行节流操作（不带值，使用 latest: false 保留第一个值）
XPThrottle.shared.execute(id: "buttonClick", interval: 1.0, latest: false, value: ()) { _ in
    print("按钮点击")
}

// 使用 DispatchQueue 扩展方法
DispatchQueue.main.throttle(id: "resize", interval: 0.1) {
    print("窗口大小改变")
}

// 取消节流操作
XPThrottle.shared.cancel(id: "scroll")
```

---

### XPAppInfo
**功能说明**：应用信息工具类，提供获取应用基本信息的便捷方法，包括应用名称、版本号、设备信息等。

**使用示例**：
```swift
// 获取应用名称
let appName = XPAppInfo.appName

// 获取应用版本号
let version = XPAppInfo.appVersion

// 获取构建版本号
let build = XPAppInfo.buildVersion

// 获取系统版本
let systemVersion = XPAppInfo.systemVersion

// 获取设备UUID
let uuid = XPAppInfo.deviceUUID

// 获取设备型号标识符
let model = XPAppInfo.deviceModel

// 获取Bundle标识符
let bundleID = XPAppInfo.bundleIdentifier
```

---

### XPImage
**功能说明**：图片工具类，提供图片创建、缩放、视频封面获取等便捷方法。

**使用示例**：
```swift
// 创建纯色图片（1x1像素）
let redImage = XPImage.image(with: .red)

// 创建指定尺寸的纯色图片
let blueImage = XPImage.image(with: .blue, size: CGSize(width: 100, height: 100))

// 缩放图片到指定尺寸
let scaledImage = XPImage.scale(image: originalImage, toSize: CGSize(width: 200, height: 200))

// 获取视频封面图
if let previewImage = XPImage.getVideoPreviewImage(with: videoURL) {
    imageView.image = previewImage
}

// 获取启动页图片
if let launchImage = XPImage.getLaunchImage() {
    // 使用启动页图片
}

// 获取应用图标
if let appIcon = XPImage.getAppIcon() {
    // 使用应用图标
}
```

---

### XPAnimation
**功能说明**：动画工具类，提供常用的缩放、旋转、透明度等动画效果。

**使用示例**：
```swift
// 由大变小再恢复的动画
view.layer.add(XPAnimation.bigToSmallRecovery(), forKey: "scale")

// 由小变大再变小的动画
view.layer.add(XPAnimation.smallToBigToSmall(), forKey: "scale")

// 原始大小缩小的动画
view.layer.add(XPAnimation.originToSmall(), forKey: "scale")

// 原始大小变大变小再恢复的动画
view.layer.add(XPAnimation.originToBigToSmallRecovery(), forKey: "scale")

// 触摸按下的脉冲动画（循环）
view.layer.add(XPAnimation.touchDownAnimation(), forKey: "pulse")

// 旋转动画
view.layer.add(XPAnimation.rotationAnimation(duration: 3), forKey: "rotation")

// 头像缩放动画（循环）
view.layer.add(XPAnimation.avatarScaleAnimation(), forKey: "avatarScale")

// 透明度动画
view.layer.add(XPAnimation.opacityAnimation(from: 0, to: 1, duration: 0.3), forKey: "fadeIn")

// 缩放动画
view.layer.add(XPAnimation.scaleAnimation(from: 0.5, to: 1, duration: 0.3), forKey: "scaleUp")
```

---

### XPTime
**功能说明**：时间工具类，提供日期格式化、时间戳转换、日期比较等常用时间操作功能。

**使用示例**：
```swift
// 获取最近N天的日期列表（格式：MM-dd）
let recentDays = XPTime.returnNearByMonth(count: 7)

// 获取最近N个月的日期列表（格式：yyyy-MM）
let recentMonths = XPTime.returnNearByYear(count: 12)

// 获取当前年份
let year = XPTime.returnYear()

// 时间戳转日期字符串
let dateStr = XPTime.dateTimeYYYYMMDD(time: 1620000000)

// 日期字符串转时间戳
let timestamp = XPTime.dateTimeYYYYMMDD(string: "2021-05-03 10:30:00")

// 获取当前日期组件
let currentYear = XPTime.currentYear()
let currentMonth = XPTime.currentMonth()
let currentDay = XPTime.currentDay()

// 获取当前日期字符串
let today = XPTime.currentDate() // "2021-05-03"
let todayMM = XPTime.currentDateMM() // "2021-05"

// 获取时间戳
let stamp = XPTime.getStamp()

// 日期转字符串
let formattedDate = XPTime.dateToDateString(Date(), dateFormat: "yyyy-MM-dd HH:mm:ss")

// 计算两个日期相差天数
let daysDiff = XPTime.dateDifference(dateA, from: dateB)

// 比较两个日期
let compareResult = XPTime.compareOneDay(oneDay: dateA, withAnotherDay: dateB)

// 时间戳转详细日期字符串
let detailStr = XPTime.timeStampToStringDetail("1620000000")

// 格式化相对时间（如：5分钟前、3小时前）
let relativeTime = XPTime.compareCurrentTime(str: "2021-05-03 08:00:00")
```

---

### XPAsync
**功能说明**：异步任务调度工具，提供便捷的异步任务调度方法，包括延迟执行、主线程执行、全局队列执行等。

**使用示例**：
```swift
// 延迟执行任务（可取消）
let task = XPAsync.delay(2.0) {
    print("延迟2秒后执行")
}
// 取消任务
XPAsync.cancel(task)

// 在主线程执行任务
XPAsync.asyncMain {
    // 更新UI操作
    label.text = "更新完成"
}

// 在全局队列执行任务
XPAsync.asyncGlobal {
    // 耗时操作
    let result = performHeavyTask()
    // 完成后回到主线程
    XPAsync.asyncMain {
        updateUI(with: result)
    }
}

// 指定QoS级别执行任务
XPAsync.asyncGlobal(qos: .background) {
    // 后台任务
}

// 延迟后在主线程执行
XPAsync.asyncAfterMain(1.5) {
    print("延迟1.5秒后在主线程执行")
}

// 异步执行任务（返回可取消的work item）
let workItem = XPAsync.async {
    // 后台任务
}
workItem.cancel()

// 异步执行任务，完成后在主线程执行回调
XPAsync.async({
    // 后台任务
    return fetchData()
}, {
    // 主线程回调
    updateUI()
})

// 延迟后异步执行任务
let delayedWork = XPAsync.asyncDelay(3.0) {
    print("延迟3秒后执行")
}
```

---

### XPLanguageManager
**功能说明**：语言管理器，用于管理应用的多语言切换功能，支持中文和英文两种语言。

**使用示例**：
```swift
// 获取当前语言
let currentLanguage = XPLanguageManager.shared.language

// 判断当前是否为中文环境
let isChinese = XPLanguageManager.localeIsChinese()

// 获取当前语言设置（从UserDefaults读取）
let savedLanguage = XPLanguageManager.currentLanguage()

// 保存语言设置
XPLanguageManager.saveLanguage(chooseLanguage: .English)

// 切换语言（带完成回调）
XPLanguageManager.shared.changeLanguage(to: .Chinese) {
    print("语言切换完成")
}

// 显示语言选择器
XPLanguageManager.shared.showLanguageSelector(in: self)

// 使用本地化字符串
let title = "Hello".localized() // 根据当前语言返回对应翻译
let englishTitle = "Hello".localized(with: .English) // 强制使用英文
```

---

## Extensions 模块

### Array+Extension
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

### String+Extension
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

### Date+Extension
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

### UIColor+Extension
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

### UIView+Extension
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

## Network 模块

### XPNetworkLoggerPlugin
**功能说明**：网络请求日志插件，用于格式化打印 Moya 请求和响应的详细信息。

**使用示例**：
```swift
// 使用默认配置
let loggerPlugin = NetworkLoggerPlugin()
let provider = MoyaProvider<MyAPI>(plugins: [loggerPlugin])

// 使用自定义配置
var config = NetworkLoggerConfig()
config.logHeaders = true
config.logHandler = { message in
    // 自定义日志输出，如写入文件或发送到服务器
    print("Custom Log: \(message)")
}
let customLogger = NetworkLoggerPlugin(config: config)
```

---

### XPBaseModel
**功能说明**：基础响应模型，封装了通用的网络响应数据结构。

**使用示例**：
```swift
// 定义API响应模型
struct UserResponse: XPBaseModel {
    var code: Int
    var message: String
    var data: User?
}

// 使用示例
provider.request(.getUser) { result in
    switch result {
    case .success(let response):
        if let userResponse = try? response.map(UserResponse.self) {
            if userResponse.isSuccess {
                print(userResponse.data)
            } else {
                print(userResponse.message)
            }
        }
    case .failure(let error):
        print(error)
    }
}
```

---

### XPReachableManager
**功能说明**：网络可达性管理器，用于监听网络状态变化。

**使用示例**：
```swift
// 开始监听网络状态
XPReachableManager.shared.startMonitoring()

// 获取当前网络状态
let status = XPReachableManager.shared.networkStatus

// 判断是否有网络
let isReachable = XPReachableManager.shared.isReachable

// 判断是否是WiFi
let isWiFi = XPReachableManager.shared.isWiFi

// 添加网络状态变化监听
XPReachableManager.shared.addListener { status in
    switch status {
    case .reachable(.wifi):
        print("WiFi连接")
    case .reachable(.cellular):
        print("蜂窝网络连接")
    case .unreachable:
        print("无网络连接")
    }
}
```

---

## Log 模块

### XPLogger
**功能说明**：日志工具类，提供不同级别的日志输出功能。

**使用示例**：
```swift
// 调试日志
XPLogger.debug("Debug message")

// 信息日志
XPLogger.info("Info message")

// 警告日志
XPLogger.warning("Warning message")

// 错误日志
XPLogger.error("Error message")

// 自定义日志级别
XPLogger.log(level: .debug, message: "Custom message")

// 设置日志级别
XPLogger.minLogLevel = .warning // 只输出警告及以上级别
```

---

## Navigator 模块

### XPNavigator
**功能说明**：路由导航工具，提供页面跳转和参数传递功能。

**使用示例**：
```swift
// 跳转到指定页面
XPNavigator.push("UserDetailViewController", parameters: ["userId": "123"])

// 弹出当前页面
XPNavigator.pop()

// 弹出到根页面
XPNavigator.popToRoot()

// 模态展示页面
XPNavigator.present("LoginViewController", parameters: nil)

// 关闭模态页面
XPNavigator.dismiss()

// 使用URL scheme跳转
XPNavigator.openURL(URL(string: "myapp://user/123")!)
```

---

## MediaPicker 模块

### XPMediaPickerTool
**功能说明**：媒体选择器工具，提供图片和视频选择功能。

**使用示例**：
```swift
// 选择图片
XPMediaPickerTool.shared.pickImage(from: self) { image in
    if let image = image {
        imageView.image = image
    }
}

// 选择视频
XPMediaPickerTool.shared.pickVideo(from: self) { videoURL in
    if let url = videoURL {
        // 处理视频
    }
}

// 选择多张图片
XPMediaPickerTool.shared.pickImages(from: self, maxCount: 9) { images in
    // 处理选中的图片数组
}

// 拍照
XPMediaPickerTool.shared.takePhoto(from: self) { image in
    if let image = image {
        imageView.image = image
    }
}
```

---

## WebView 模块

### XPWebPageController
**功能说明**：网页控制器，封装了 WKWebView 的常用功能。

**使用示例**：
```swift
// 创建网页控制器
let webController = XPWebPageController()
webController.urlString = "https://www.example.com"
navigationController?.pushViewController(webController, animated: true)

// 加载本地HTML文件
webController.loadLocalHTML("index.html")

// 加载HTML字符串
webController.loadHTMLString("<html><body>Hello</body></html>")

// 注入JavaScript
webController.evaluateJavaScript("document.title") { result, error in
    if let title = result as? String {
        print(title)
    }
}

// 监听网页加载进度
webController.progressHandler = { progress in
    progressView.progress = progress
}
```

---

## Toast 模块

### XPToast
**功能说明**：Toast 提示工具，提供简洁的消息提示功能。

**使用示例**：
```swift
// 显示Toast提示
XPToast.show("操作成功")

// 显示带图标的Toast
XPToast.show("操作成功", icon: .success)

// 显示错误提示
XPToast.showError("操作失败")

// 显示警告提示
XPToast.showWarning("请注意")

// 自定义Toast位置
XPToast.show("提示", position: .top)

// 自定义Toast时长
XPToast.show("提示", duration: 3)
```

---

## 命名空间说明

XPBase 使用 `XP<Base>` 结构体实现命名空间模式，通过扩展 `XPCompatible` 协议为任意类型添加扩展方法：

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

---

## 总结

XPBase 框架提供了丰富的工具类和扩展方法，涵盖了 UIKit、网络请求、日志、导航、媒体处理等多个方面，旨在提高 iOS 开发效率和代码质量。
