# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Mushrif Cafe' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mushrif Cafe
	pod 'Alamofire', '5.9.0'
  pod 'SwiftyJSON', '~> 5.0.2'
  pod 'ReachabilitySwift'
  pod 'SDWebImage'
	pod 'IQKeyboardManagerSwift'
  pod 'ProgressHUD'
  pod 'SYBanner'
  pod 'Siren'
  pod 'MyFatoorah'
  pod 'EasyNotificationBadge'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "16.0"
    end
  end
end
