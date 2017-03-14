#
# Be sure to run `pod lib lint BubblePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BubblePicker'
  s.version          = '0.1.0'
  s.summary          = 'An easy-to-use picker view built on UIKitDynamics which can be used for content picking for iOS'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An easy-to-use picker view built on UIKitDynamics which can be used for content picking for iOS.
                       DESC

  s.homepage         = 'https://github.com/Ronnel/BubblePicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ronnel Davis' => 'ronnel_davis@yahoo.com' }
  s.source           = { :git => 'https://github.com/Ronnel/BubblePicker.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ronneldavis'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BubblePicker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BubblePicker' => ['BubblePicker/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
