Pod::Spec.new do |s|
    s.name                  = "FluctSDK-MediationAdapter"
    s.summary               = "Mediation Adapter for FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.13.0"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.platform              = :ios
    s.ios.deployment_target = "9.0"
    s.cocoapods_version     = ">= 1.9.0"

    s.subspec "AdColony" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AdColony/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "AdColony", '>= 4.3.1'
    end

    s.subspec "AdCorsa" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AdCorsa/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "GlossomAds", '>= 2.2.2'
    end

    s.subspec "AppLovin" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AppLovin/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "AppLovinSDK", '>=6.14.2'
    end

    s.subspec "maio" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/maio/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "MaioSDK", '>= 1.5.5'
    end

    s.subspec "nend" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/nend/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "NendSDK_iOS", '= 7.0.0'
    end

    s.subspec "Tapjoy" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Tapjoy/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "TapjoySDK", '>= 12.7.0'
    end

    s.subspec "UnityAds" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/UnityAds/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.dependency "UnityAds", '>= 3.5.1'
    end

    s.subspec "Five" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Five/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.12.4"
        ss.frameworks = "AdSupport", "AVFoundation", "CoreMedia", "CoreTelephony", "SystemConfiguration", "AudioToolbox", "WebKit", "StoreKit"
        ss.vendored_frameworks = "FluctSDK-MediationAdapter/Five/FiveAd.framework"
    end
end
