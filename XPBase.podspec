#
# Be sure to run `pod lib lint XPBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XPBase'
  s.version          = '0.1.0'
  s.summary          = 'A short description of XPBase.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/roc-mini/XPBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'roc-mini' => 'cjdesyue@126.com' }
  s.source           = { :git => 'https://github.com/travelcookies/XPBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

   s.source_files = 'XPBase/Classes/**/*'

  # 拓展
  s.subspec 'Extensions' do |ss|
    ss.source_files = 'XPBase/Classes/Extensions'
  end

  # 网络请求
  s.subspec 'API' do |ss|
    ss.source_files = 'XPBase/Classes/API'
    ss.source_files = 'XPBase/Classes/API/**/*'
  end

  # 提示
  s.subspec 'Log' do |ss|
    ss.source_files = 'XPBase/Classes/Log'
  end

  # 工具
  s.subspec 'Tool' do |ss|
    ss.source_files = 'XPBase/Classes/Tool'
#    ss.source_files = 'XPBase/Classes/Tool/**/*'
  end


  s.frameworks = 'UIKit'
  s.dependency 'Alamofire'
  s.dependency 'Moya'
  s.dependency 'HandyJSON'
  s.dependency 'SnapKit'
  s.dependency 'Toast-Swift'
  s.dependency 'ReachabilitySwift'
  s.dependency 'GKNavigationBar/NavigationBar'
 end
