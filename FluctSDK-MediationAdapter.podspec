Pod::Spec.new do |s|
    s.name                  = "FluctSDK-MediationAdapter"
    s.summary               = "Mediation Adapter for FluctSDK ad Framework"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.39.5"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.platform              = :ios
    s.ios.deployment_target = "9.0"
    s.swift_version         = "5.0"
    s.cocoapods_version     = ">= 1.9.0"
    s.default_subspec = "Core"

    s.subspec "Core" do |ss|
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.ios.deployment_target = "9.0"
    end

    s.subspec "AppLovin" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/AppLovin/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "AppLovinSDK", '=13.3.0'
        ss.ios.deployment_target = "12.0"
    end

    s.subspec "maio" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/maio/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "MaioSDK-v2", '=2.1.6'
        ss.ios.deployment_target = "14.0"
    end

    s.subspec "UnityAds" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/UnityAds/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "UnityAds", '=4.15.0'
        ss.ios.deployment_target = "12.0"
    end

    s.subspec "Five" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Five/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "FiveAd", '=2.9.20250512'
        ss.ios.deployment_target = "15.0"
    end

    s.subspec "Pangle" do |ss|
        ss.source_files = "FluctSDK-MediationAdapter/Pangle/*.{h,m}"
        ss.dependency "FluctSDK", ">=6.14.0"
        ss.dependency "Ads-Global", '7.1.1.1'
        ss.ios.deployment_target = "12.0"
    end
end
