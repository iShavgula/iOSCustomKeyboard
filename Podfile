platform :ios, '9.0'
use_frameworks!

def available_pods
    pod 'RealmSwift'
    pod 'TurtleBezierPath'
    pod 'JASON'
    pod 'ObjectMapper'
end

abstract_target 'GK' do
    available_pods
    target 'Georgian Keyboard'
    target 'Keyboard'
end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        # Configure Pod targets for Xcode 8 compatibility
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = '62CV7SV593/'
    end
    #installer.pods_project.targets.each do |target|
    #   target.build_configurations.each do |config|
    #       config.build_settings['SWIFT_VERSION'] = '3.0'
    #   end
    #end
end
