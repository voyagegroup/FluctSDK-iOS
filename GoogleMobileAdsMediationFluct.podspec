Pod::Spec.new do |s|
    s.name                  = "GoogleMobileAdsMediationFluct"
    s.summary               = "fluct adapter used for mediation with the Google Mobile Ads SDK"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.11.4"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "GoogleMobileAdsMediationFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "9.0"
    s.dependency "FluctSDK", ">= 6.6.0"
    s.dependency "Google-Mobile-Ads-SDK", ">= 7.42.2"
    s.xcconfig              = { "EXCLUDED_ARCHS[sdk=iphonesimulator*]" => "arm64" }
end
