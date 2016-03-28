Pod::Spec.new do |s|
  s.name         = "SAUIKitTool"
  s.version      = "0.0.1"
  s.summary      = "UIKit工具类"
  s.license      = 'MIT'
  s.author       = { "XB-Paul" => "zhanxuebao@outlook.com" }
  s.homepage     = 'https://github.com/XB-Paul/SAUIKit'
  s.platform     = :ios,'7.0'
  s.ios.deployment_target = '7.0'
s.source       = { :git => "https://github.com/XB-Paul/SAUIKit.git", :tag => s.version.to_s}
  s.requires_arc = true
  s.subspec 'SAUIKitMeans' do |ss|
    ss.source_files = 'SAUIKit/SAUIKitMeans/*.{h,m}'
  end
  s.subspec 'SAUIKitCategory' do |ss|
    ss.source_files = 'SAUIKit/SAUIKitCategory/*.{h,m}'
  end
  s.dependency 'MBProgressHUD', '~> 0.9.2'
end