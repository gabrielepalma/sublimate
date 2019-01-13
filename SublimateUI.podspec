#
# Be sure to run `pod lib lint SublimateUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SublimateUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of SublimateUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Mock UI to enable automatic generation of tables in Sublimate.
                       DESC

  s.homepage         = 'https://github.com/gabrielepalma/sublimate'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gabriele' => 'gabrielepalma82@gmail.com' }
  s.source           = { :git => 'https://github.com/gabrielepalma/sublimate.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'

  s.source_files = 'SublimateUI/SublimateUI/Classes/**/*.swift'
  s.resources = 'SublimateUI/SublimateUI/Resources/*.{xib,storyboard}'

  s.frameworks = 'UIKit'

  s.dependency 'KeychainAccess'
  s.dependency 'RxCocoa'
  s.dependency 'PromiseKit'
  s.dependency 'RxSwift'
  s.dependency 'RealmSwift'
  s.dependency 'RxRealm'
  s.dependency 'ReachabilitySwift'
  s.dependency 'SwiftMessages'
  s.dependency 'SublimateSync'
  s.dependency 'RxRealmDataSources'

end


