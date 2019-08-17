# Uncomment the next line to define a global platform for your project
use_modular_headers!
platform :ios, '11.0'

target 'BreadboardSimulator' do

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BreadboardSimulator
  pod 'SwiftFormat/CLI'
  pod 'Crashlytics'
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa', '~> 4.0'
  
  target 'BreadboardSimulatorTests' do
    inherit! :search_paths
    pod 'Quick', '~> 1.3'
    pod 'Nimble', '~> 7.1'
    pod 'RxTest', '~> 4.0'
    pod 'RxBlocking', '~> 4.0'
  end
  
end

target 'BreadboardSimulatorUITests' do
  inherit! :search_paths
  # Pods for testing
end
