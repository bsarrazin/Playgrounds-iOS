inhibit_all_warnings!
platform :ios, '11.3'

bb_options = {
  git: 'git@github.com:bsarrazin/ios.BuildingBlocks'
}

target 'Playground' do
  use_frameworks!
  pod 'Alamofire'
  pod 'BuildingBlocks/Containers', bb_options
  pod 'BuildingBlocks/FoundationExtensions', bb_options
  pod 'BuildingBlocks/Loggable', bb_options
  pod 'BuildingBlocks/MVVM', bb_options
  pod 'BuildingBlocks/RxExtensions', bb_options
  pod 'BuildingBlocks/Sugar', bb_options
  pod 'BuildingBlocks/Result', bb_options
  pod 'BuildingBlocks/StateMachine', bb_options
  pod 'BuildingBlocks/SubscriptionStore', bb_options
  pod 'BuildingBlocks/UIKitExtensions', bb_options
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
