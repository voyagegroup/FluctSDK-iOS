Pod::Spec.new do |s|
    s.name                  = "MoPubMediationAdapterFluct"
    s.summary               = "fluct adapter used for mediation with the MoPub"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.5.0"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "MoPubMediationAdapterFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "9.0"
    s.dependency "FluctSDK", ">= 6.5.0"
    s.dependency "mopub-ios-sdk", ">= 5.10.0"
end
