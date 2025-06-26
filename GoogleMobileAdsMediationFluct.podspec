Pod::Spec.new do |s|
    s.name                  = "GoogleMobileAdsMediationFluct"
    s.summary               = "fluct adapter used for mediation with the Google Mobile Ads SDK"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.39.5"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "GoogleMobileAdsMediationFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "10.0"
    s.dependency "FluctSDK", ">= 6.12.1"
    s.dependency "Google-Mobile-Ads-SDK", ">= 9.8.0"
    s.cocoapods_version     = ">= 1.9.0"
end
