Pod::Spec.new do |s|
    s.name                  = "MoPubMediationAdapterFluct"
    s.summary               = "fluct adapter used for mediation with the MoPub"
    s.license               = { :type => "Copyright", :text => "Copyright (c) fluct,Inc. All rights reserved." }
    s.version               = "6.13.9"
    s.author                = "fluct,Inc."
    s.requires_arc          = true
    s.static_framework      = true
    s.homepage              = "https://fluct.jp/"
    s.source                = { :git => "https://github.com/voyagegroup/FluctSDK-iOS.git", :tag => s.version }
    s.source_files          = "MoPubMediationAdapterFluct/*.{h,m}"
    s.platform              = :ios
    s.ios.deployment_target = "10.0"
    s.dependency "FluctSDK", ">= 6.12.1"
    s.dependency "mopub-ios-sdk", ">= 5.17.0"
    s.cocoapods_version     = ">= 1.9.0"
end
