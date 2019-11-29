Pod::Spec.new do |s|
    s.name                  = "FluctSDK-MediationAdapter"
    s.summary               = "Mediation Adapter for FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "5.16.0"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.platform              = :ios
    s.ios.deployment_target = "8.1"

    s.subspec "AdColony" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AdColony/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "AdColony"
    end

    s.subspec "AdCorsa" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AdCorsa/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "GlossomAds"
    end

    s.subspec "AppLovin" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AppLovin/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "AppLovinSDK"
    end

    s.subspec "maio" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/maio/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "MaioSDK"
    end

    s.subspec "nend" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/nend/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "NendSDK_iOS"
    end

    s.subspec "Tapjoy" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Tapjoy/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "TapjoySDK"
    end

    s.subspec "UnityAds" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/UnityAds/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "UnityAds"
    end

    s.subspec "Mintegral" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Mintegral/*.{h,m}"
        ss.dependency "FluctSDK"
        ss.dependency "MintegralAdSDK/RewardVideoAd"
    end
end
