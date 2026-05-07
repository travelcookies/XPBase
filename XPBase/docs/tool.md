# Tool 模块

## XPTimer

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

## XPDebounce

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

## XPThrottle

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

## XPAppInfo

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

## XPImage

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

## XPAnimation

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

## XPTime

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

## XPAsync

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

## XPLanguageManager

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

## XPCounter

**功能说明**：数字动画计数器，使用 CADisplayLink 实现流畅的数值变化动画，支持缓动效果。

**使用示例**：
```swift
// 数字从 0 到 100 的动画，持续 2 秒
XPCounter.animate(from: 0, to: 100, duration: 2) { value in
    label.text = String(format: "%.0f", value)
} completion: {
    print("动画完成")
}

// 带小数的数字动画
XPCounter.animate(from: 0, to: 3.14, duration: 1.5) { value in
    label.text = String(format: "%.2f", value)
}
```

---

## XPMarqueeView

**功能说明**：跑马灯视图，支持向上和向左两种滚动方向，支持自定义数据和点击事件。

**使用示例**：
```swift
// 创建跑马灯视图（向左滚动）
let marqueeView = XPMarqueeView(direction: .leftward)
marqueeView.dataSource = self
marqueeView.delegate = self
marqueeView.timeInterval = 3 // 滚动间隔时间
marqueeView.itemSpacing = 10 // 间距
view.addSubview(marqueeView)

// 开始滚动
marqueeView.start()

// 暂停滚动
marqueeView.pause()

// MARK: - XPMarqueeViewDataSource
func numberOfItems(in marqueeView: XPMarqueeView) -> Int {
    return dataArray.count
}

func marqueeView(_ marqueeView: XPMarqueeView, viewForItemAt index: Int) -> UIView {
    let label = UILabel()
    label.text = dataArray[index]
    return label
}

// MARK: - XPMarqueeViewDelegate
func marqueeView(_ marqueeView: XPMarqueeView, didSelectItemAt index: Int) {
    print("选中第 \(index) 项")
}
```

---

## XPFileManager

**功能说明**：文件管理器工具类，提供文件系统常用操作，包括目录获取、文件删除、文件大小计算等。

**使用示例**：
```swift
// 获取常用目录路径
let docsPath = XPFileManager.shared.documentsDirectory
let cachePath = XPFileManager.shared.cacheDirectory
let tempPath = XPFileManager.shared.temporaryDirectory

// 检查文件是否存在
let exists = XPFileManager.shared.fileExists(atPath: filePath)

// 获取文件大小
let size = XPFileManager.shared.fileSize(atPath: filePath)

// 删除文件夹中所有文件
XPFileManager.shared.removeAllFiles(in: cachePath)

// 删除指定扩展名的文件
XPFileManager.shared.removeAllFiles(in: tempPath, withExtension: ".tmp")

// 创建目录
try XPFileManager.shared.createDirectory(atPath: customPath)

// 复制文件
try XPFileManager.shared.copyFile(from: sourcePath, to: destPath)
```

---

## XPCacheManager

**功能说明**：缓存管理器，提供基于文件系统的缓存功能，支持线程安全的读写操作。

**使用示例**：
```swift
// 创建缓存管理器实例
let cache = XPCacheManager(name: "MyCache")

// 保存缓存
cache.addUpdateCache(key: "user_info", value: userDictionary)

// 获取缓存
if let userInfo = cache.obtainCache(key: "user_info") as? [String: Any] {
    print(userInfo)
}

// 删除指定缓存
cache.removeCache(key: "user_info")

// 清空所有缓存
cache.removeAllCache()
```

---

## XPKeyChain

**功能说明**：KeyChain 工具类，提供安全的数据存储功能，基于 iOS KeyChain 服务实现。

**使用示例**：
```swift
// 保存数据
let data = "secret_data".data(using: .utf8)!
let status = XPKeyChain.save(service: "MyApp", data: data)
if status == errSecSuccess {
    print("保存成功")
}

// 读取数据
if let loadedData = XPKeyChain.load(service: "MyApp") {
    let value = String(data: loadedData, encoding: .utf8)
    print(value ?? "")
}

// 删除数据
XPKeyChain.delete(service: "MyApp")

// 快捷方法保存字符串
let success = XPKeyChain.saveString(service: "token", value: "abc123")

// 快捷方法读取字符串
let token = XPKeyChain.loadString(service: "token")
```
