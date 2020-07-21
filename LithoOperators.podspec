#
# Be sure to run `pod lib lint LithoOperators.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LithoOperators'
  s.version          = '0.0.11'
  s.summary          = 'LithoOperators contains some nice operators to make functional programming easier.'
  s.swift_versions   = ['4.0', '4.2', '5.0', '5.1', '5.2']

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
LithoOperators contains some nice operators to make functional programming easier. Many of these come from the excellent pointfree.co videos! Check them out for more!
                       DESC

  s.homepage         = 'https://github.com/ThryvInc/LithoOperators'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Elliot' => '' }
  s.source           = { :git => 'https://github.com/ThryvInc/LithoOperators.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/elliot_schrock'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LithoOperators/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LithoOperators' => ['LithoOperators/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Prelude'
end
