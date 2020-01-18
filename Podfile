inhibit_all_warnings!
platform :ios, '13.2'

fk_options = {
  git: 'git@github.com:bsarrazin/io.srz.FoundationKit.ios'
}

target 'Playground' do
  use_frameworks!

  pod 'Alamofire'
  pod 'RxCocoa'
  pod 'RxSwift'
  pod 'Stencil'

  pod 'FoundationKit/Containers', fk_options
  pod 'FoundationKit/FoundationExtensions', fk_options
  pod 'FoundationKit/Loggable', fk_options
  pod 'FoundationKit/MVVM', fk_options
  pod 'FoundationKit/Result', fk_options
  pod 'FoundationKit/RxExtensions', fk_options
  pod 'FoundationKit/StateMachine', fk_options
  pod 'FoundationKit/SubscriptionStore', fk_options
  pod 'FoundationKit/Sugar', fk_options
  pod 'FoundationKit/UIKitExtensions', fk_options
end

# Workaround for Cocoapods issue #7606
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
