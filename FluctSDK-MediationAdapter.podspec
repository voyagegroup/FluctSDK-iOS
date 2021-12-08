Pod::Spec.new do |s|
    s.name                  = "FluctSDK-MediationAdapter"
    s.summary               = "Mediation Adapter for FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.14.6"
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
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "AdColony", '>= 4.3.1'
    end

    s.subspec "AdCorsa" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AdCorsa/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "GlossomAds", '>= 2.2.2'
    end

    s.subspec "AppLovin" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AppLovin/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "AppLovinSDK", '>=10.3.5'
    end

    s.subspec "maio" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/maio/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "MaioSDK", '>= 1.5.8'
    end

    s.subspec "nend" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/nend/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "NendSDK_iOS", '>= 7.0.4'
    end

    s.subspec "Tapjoy" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Tapjoy/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "TapjoySDK", '>= 12.8.0'
    end

    s.subspec "UnityAds" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/UnityAds/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "UnityAds", '= 3.7.5'
    end

    s.subspec "Five" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Five/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "FiveAd", '>= 2.4.20211004'
    end

    s.subspec "Pangle" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Pangle/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "Ads-Global", '>= 3.4.2.3'
    end
end
