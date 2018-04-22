#
#  Be sure to run `pod spec lint UBAlipayTool.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'UBAlipayTool'
  s.version          = '1.0.0'
  s.summary          = 'UBAlipayTool 封装了alipay'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
UBAlipayTool 封装了alipay
                       DESC

  s.homepage         = 'https://github.com/Crazysiri/UBAlipayTool.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'James' => '511121933@qq.com' }
  s.source           = { :git => 'https://github.com/Crazysiri/UBAlipayTool.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, "7.0"
  s.ios.deployment_target = '7.0'

  s.source_files = 'AlipaySDKNeeds/Classes/**/*.{h,m}'
  
  s.dependency 'UBAlipaySDK'

  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/UBAlipaySDK',
    'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup'
  }

  s.subspec 'Util' do |util|
    util.source_files = 'AlipaySDKNeeds/Util/**/*.{h,m}'
    util.dependency 'AlipaySDKNeeds/OpenSSL'
  end
  
  s.subspec 'OpenSSL' do |openssl|
    openssl.source_files = 'AlipaySDKNeeds/Openssl/**/*.h'
    openssl.public_header_files = 'AlipaySDKNeeds/Openssl/**/*.h'
    openssl.ios.preserve_paths      = 'AlipaySDKNeeds/Library/libcrypto.a', 'AlipayWrapper/Library/libssl.a'
    openssl.ios.vendored_libraries  = 'AlipaySDKNeeds/Library/libcrypto.a', 'AlipayWrapper/Library/libssl.a'
    openssl.libraries = 'ssl', 'crypto'
    openssl.xcconfig = { 'HEADER_SEARCH_PATHS' => "${PODS_ROOT}/#{s.name}/AlipaySDKNeeds/Openssl/**" }
  end

end