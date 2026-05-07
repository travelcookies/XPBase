# MediaPicker 模块

## XPMediaPickerTool

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
