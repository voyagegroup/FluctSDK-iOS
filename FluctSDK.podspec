Pod::Spec.new do |s|
    s.name                  = "FluctSDK"
    s.summary               = "FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.6.0"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.resource              = "FluctSDK.embeddedframework/Resources/FluctSDKResources.bundle"
    s.vendored_frameworks   = "FluctSDK.embeddedframework/FluctSDK.framework"
    s.platform              = :ios
    s.ios.deployment_target = "8.1"
    s.compiler_flags        = "-ObjC"
    s.frameworks            = "AdSupport", "CoreTelephony", "MediaPlayer", "CoreMedia", "SystemConfiguration", "StoreKit", "Social", "AVFoundation", "WebKit"
    s.libraries             = "xml2"
end
