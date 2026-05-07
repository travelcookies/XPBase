# Toast 模块

## XPToast

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
