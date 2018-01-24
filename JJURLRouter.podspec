#
#  Be sure to run `pod spec lint YZT_iOS_UrlRouterService.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "JJURLRouter"
  s.version      = "0.0.1"
  s.summary      = "URL Router"
  s.license      = "MIT"
  s.homepage     = "https://github.com/hamilyjing/JJURLRouter"
  s.author       = { "JJ" => "gongjian_001@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/hamilyjing/JJURLRouter.git", :tag => s.version }
  
  s.source_files = "JJURLRouter/**/*.{h,m}"

  s.frameworks = "Foundation", "UIKit"

  s.dependency 'YYModel', '1.0.4'
  
end
