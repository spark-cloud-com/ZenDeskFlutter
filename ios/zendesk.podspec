#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'zendesk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter interface for Zendesk Mobile SDK'
  s.description      = <<-DESC
Flutter interface for Zendesk Mobile SDK
                       DESC
  s.homepage         = 'https://github.com/emostar/flutter-zendesk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Codehead Labs' => 'oss@codeheadlabs.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'ZendeskChatSDK'
  s.ios.deployment_target = '12.0'
  s.platform = '12.0'

end