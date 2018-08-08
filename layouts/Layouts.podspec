#
#  Be sure to run `pod spec lint Layouts.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "Layouts"
  s.version      = "0.0.1"
  s.summary      = "Conventional over configuration fluent layout system"
  s.description  = <<-DESC
                    Conventional over configuration, NSLayoutConstraint based layout system for Swift. Programmatically layout your UI like never before                  
                   DESC

  s.homepage     = "https://github.com/will3/layouts"
  s.license      = "MIT"
  s.ios.deployment_target  = '10.0'
  s.author             = { "will3" => "will3.git@gmail.com" }
  s.source       = { :git => "https://github.com/will3/layouts.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
end
