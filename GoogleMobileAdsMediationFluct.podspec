Pod::Spec.new do |s|
    s.name                  = "GoogleMobileAdsMediationFluct"
    s.summary               = "fluct adapter used for mediation with the Google Mobile Ads SDK"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "5.12.2"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "GoogleMobileAdsMediationFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "8.1"
    s.dependency "FluctSDK", ">= 5.4.0"
    s.dependency "Google-Mobile-Ads-SDK", ">= 7.42.2"
end
