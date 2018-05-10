
inhibit_all_warnings!
platform :ios, '11.3'

target 'Playground' do
  use_frameworks!
  pod 'Alamofire'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Stencil'
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
