#
# Be sure to run `pod lib lint MileusWatchdogKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MileusWatchdogKit'
  s.version          = '2.0.1'
  s.summary          = 'Mileus Watchdog iOS Kit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Mileus Watchdog iOS Kit with Example.
                       DESC

  s.homepage         = 'https://github.com/mileus/watchdog-sdk-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mileus' => 'cocoapods@mileus.com' }
  s.source           = { :git => 'https://github.com/mileus/watchdog-sdk-ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = '5.0'

  s.source_files = 'MileusWatchdogKit/**/*.{h,m,swift}'
  
  s.resource = 'MileusWatchdogKit/**/*.{xib,storyboard,strings}'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
