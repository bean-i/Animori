# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

platform :ios, '12.0'

target 'Animori' do
  use_frameworks!
  
  pod 'FSPagerView'
  pod 'Floaty', '~> 4.2.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
end
