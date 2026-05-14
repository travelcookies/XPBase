# UIKit 模块

## XPScreen

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

## XPDevice

**功能说明**：设备信息工具类，提供设备相关信息的获取方法，包括设备型号、系统版本、应用信息等。

**使用示例**：
```swift
// 获取设备名称
let deviceName = XPDevice.shared.name // 如 "iPhone 13"

// 获取设备显示名称
let displayName = XPDevice.shared.deviceName // 如 "张三的 iPhone"

// 获取系统名称
let systemName = XPDevice.shared.sysName // "iOS"

// 获取系统版本
let systemVersion = XPDevice.shared.sysVersion // "15.0"

// 获取设备UUID
let uuid = XPDevice.shared.deviceUUID

// 获取设备型号
let model = XPDevice.shared.deviceModel // "iPhone"

// 获取应用版本号
let appVersion = XPDevice.shared.appVersion // "1.0.0"

// 获取应用构建版本
let buildVersion = XPDevice.shared.appBuildVersion // "1"

// 获取应用名称
let appName = XPDevice.shared.appName // "MyApp"
```

---

## XPColor

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

## XPFont

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

## XPUnderlineButton

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

## XPUnderlineTextField

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

## XPCountDownButton

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

## XPDashedBorderView

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

## XPGradientButton

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

## XPGradientView

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

## XPRootViewControllerManager

**功能说明**：视图控制器管理器，提供获取当前显示视图控制器的便捷方法，支持多种视图层级结构。

**使用示例**：
```swift
// 获取当前视图控制器
if let currentVC = XPRootViewControllerManager.currentViewController() {
    print("当前视图控制器: \(String(describing: type(of: currentVC)))")
}

// 使用计算属性获取当前视图控制器
if let currentVC = XPRootViewControllerManager.currentVC {
    // 执行操作
}

// 获取当前导航控制器
if let navVC = XPRootViewControllerManager.currentNavigationController() {
    navVC.pushViewController(DetailViewController(), animated: true)
}

// 获取当前标签页控制器
if let tabVC = XPRootViewControllerManager.currentTabBarController() {
    tabVC.selectedIndex = 1
}

// 安全获取当前视图控制器（带后备值）
let vc = XPRootViewControllerManager.safeCurrentViewController()
present(alertVC, animated: true)

// 获取应用主窗口
if let window = XPRootViewControllerManager.keyWindow() {
    window.rootViewController = MainTabBarController()
}
```

---

## XPDeviceModelConfiguration

**功能说明**：设备型号配置，存储设备标识符与设备名称的映射关系，便于维护和扩展。

**使用示例**：
```swift
// 获取设备名称
let deviceName = XPDeviceModelConfiguration.deviceNames["iPhone16,1"] ?? "Unknown"
print(deviceName) // "iPhone 15 Pro"

// 获取安全区域配置
let insets = XPDeviceModelConfiguration.safeAreaInsetsDict["iPhone15,4"]?[.portrait]

// 判断是否灵动岛设备
let isDynamicIsland = XPDeviceModelConfiguration.dynamicIslandDeviceModels.contains(deviceModel)
```

**主要配置项**：

| 属性 | 类型 | 说明 |
|------|------|------|
| `deviceNames` | `[String: String]` | 设备标识符到设备名称的映射 |
| `dynamicIslandDeviceModels` | `[String]` | 灵动岛设备型号列表 |
| `safeAreaInsetsDict` | `[String: [UIInterfaceOrientation: UIEdgeInsets]]` | 安全区域内边距配置 |
| `screenXXInchModels` | `[String]` | 各尺寸屏幕设备型号列表 |
