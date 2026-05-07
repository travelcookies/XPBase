#
# Be sure to run `pod lib lint XPBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XPBase'
  s.version          = '1.2.0'
  s.summary          = 'iOS 开发基础工具库，提供屏幕适配、网络请求、UI组件、日志等常用功能。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
XPBase 是一个功能丰富的 iOS 开发基础工具库，包含以下核心模块：

UIKit 模块
- XPScreen: 屏幕信息工具类，提供全面的屏幕尺寸、设备类型、安全区域等信息
- XPDevice: 设备信息工具类
- XPColor/XPFont: 颜色和字体工具类
- 各种自定义 UI 组件（XPUnderlineButton、XPCountDownButton 等）

Tool 模块
- XPTimer: 线程安全的定时器管理
- XPDebounce/XPThrottle: 防抖和节流工具
- XPAsync: 异步任务调度
- XPTime: 时间工具类
- XPCacheManager/XPKeyChain: 缓存和安全存储

Network 模块
- 基于 Moya 的网络请求封装
- XPNetworkLoggerPlugin: 网络日志插件
- XPReachableManager: 网络可达性监听

Extensions 模块
- 丰富的 Swift 扩展（Array、String、Date、UIColor、UIView）

详细文档请参考 docs/ 目录。
                       DESC

  s.homepage         = 'https://github.com/travelcookies/XPBase'
  s.documentation_url = 'https://github.com/travelcookies/XPBase/tree/main/XPBase/docs'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'roc-mini' => 'cjdesyue@126.com' }
  s.source           = { :git => 'https://github.com/travelcookies/XPBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  # s.source_files = 'XPBase/Classes/**/*'

  # 资源文件
  s.resource_bundles = {
    'XPBase' => ['XPBase/Classes/**/*.xib', 'XPBase/Classes/**/*.png', 'XPBase/Classes/**/*.jpg', 'XPBase/Classes/**/*.jpeg', 'XPBase/Classes/**/*.gif']
  }

  # 拓展
  s.subspec 'Extensions' do |ss|
    ss.source_files = 'XPBase/Classes/Extensions/**/*'
  end

  # 网络请求
  s.subspec 'Network' do |ss|
    ss.source_files = 'XPBase/Classes/Network/**/*'
    ss.dependency 'XPBase/Extensions'
    ss.dependency 'XPBase/UIKit'
  end

  # UIKit工具类
  s.subspec 'UIKit' do |ss|
    ss.source_files = 'XPBase/Classes/UIKit/**/*'
    ss.dependency 'XPBase/Extensions'
  end

  # 提示
  s.subspec 'Log' do |ss|
    ss.source_files = 'XPBase/Classes/Log/**/*'
  end

  # 工具
  s.subspec 'Tool' do |ss|
    ss.source_files = 'XPBase/Classes/Tool/**/*'
    ss.dependency 'XPBase/UIKit'
    ss.dependency 'XPBase/Network'
  end


  s.frameworks = 'UIKit'
  s.dependency 'Alamofire'
  s.dependency 'Moya'
  s.dependency 'HandyJSON'
  s.dependency 'SnapKit'
  s.dependency 'Toast-Swift'
  s.dependency 'ReachabilitySwift'
  s.dependency 'GKNavigationBar/NavigationBar'
  s.dependency 'URLNavigator'

 end