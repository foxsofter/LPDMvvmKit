#
#  Be sure to run `pod spec lint LPDMvvmKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "LPDMvvmKit"
  s.version      = "1.0.1"
  s.summary      = "Elegant MVVM framework in Objective-C. "

  s.description  = <<-DESC
  LPDMvvmKit - Elegant MVVM framework in Objective-C.
                   DESC

  s.homepage     = "https://github.com/LPD-iOS/LPDMvvmKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "foxsofter" => "foxsofter@gmail.com" }
  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"

  s.source = { :git => "https://github.com/LPD-iOS/LPDMvvmKit.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.source_files = 'LPDMvvmKit/Classes/**/*'

  # s.resource_bundles = {
  #   'LPDMvvmKit' => ['LPDMvvmKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit'
  s.dependency 'LPDAdditionsKit'
  s.dependency 'LPDControlsKit'
  s.dependency 'LPDNetworkingKit'
  s.dependency 'LPDTableViewKit'
  s.dependency 'LPDCollectionViewKit'
  s.dependency 'ReactiveObjC'
  s.dependency 'MJRefresh'
end
