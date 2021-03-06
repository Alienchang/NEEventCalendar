#
# Be sure to run `pod lib lint NEEventCalendar.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NEEventCalendar'
  s.version          = '1.0.0'
  s.summary          = '日历添加事件封装'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
textField和textView的封装.
                       DESC

  s.homepage         = 'https://github.com/Alienchang/NEEventCalendar.git'
  s.license          = 'MIT'
  s.author           = { 'liuchang' => '1217493217@qq.com' }
  s.source           = { :git => 'https://github.com/Alienchang/NEEventCalendar.git', :tag => s.version.to_s }

  s.module_name = 'NEEventCalendar'
  s.requires_arc          = true
  s.ios.deployment_target = '9.0'
  s.source_files = 'Classes/**/*.{h,m,mm}'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks = 'EventKit'
end
