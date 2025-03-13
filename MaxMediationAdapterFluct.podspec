Pod::Spec.new do |s|
    s.name                  = "MaxMediationAdapterFluct"
    s.summary               = "fluct adapter used for mediation with the AppLovin MAX SDK"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.39.1"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "MaxMediationAdapterFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "11.0"
    s.dependency "FluctSDK", ">= 6.19.0"
    s.dependency "AppLovinSDK", ">= 13.0.0"
    s.cocoapods_version     = ">= 1.9.0"
end
