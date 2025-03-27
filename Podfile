# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Animori' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'FSPagerView'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')

        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
  # Pods for Animori

end
