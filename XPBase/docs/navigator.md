# Navigator 模块

## XPNavigator

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
