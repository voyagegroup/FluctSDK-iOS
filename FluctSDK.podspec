Pod::Spec.new do |s|
    s.name                  = "FluctSDK"
    s.summary               = "FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.39.5"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.resource              = "FluctSDK.embeddedframework/Resources/FluctSDKResources.bundle"
    s.vendored_frameworks   = "FluctSDK.embeddedframework/FluctSDK.xcframework"
    s.platform              = :ios
    s.ios.deployment_target = "9.0"
    s.compiler_flags        = "-ObjC"
    s.frameworks            = "AdSupport", "CoreTelephony", "MediaPlayer", "CoreMedia", "SystemConfiguration", "StoreKit", "Social", "AVFoundation", "WebKit"
    s.weak_framework        = 'AppTrackingTransparency'
    s.cocoapods_version     = ">= 1.9.0"
end
