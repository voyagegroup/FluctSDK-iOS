//
//  FiveAd.h
//  FiveAd
//
//  Created by Yusuke Konishi on 2014/11/12.
//  Copyright (c) 2014年 Five. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WKUserContentController;

/******************************************************************************
 * What we defined on this header.
 ******************************************************************************/
@protocol FADAdInterface;
@protocol FADDelegate;

@class FADConfig;
@class FADSettings;
@class FADInterstitial;
@class FADInFeed;
@class FADAdViewW320H180;

typedef enum: NSInteger {
  kFADErrorNone = 0,
  kFADErrorNetworkError = 1,
  kFADErrorNoCachedAd = 2,
  kFADErrorNoFill = 3,
  kFADErrorBadAppId = 4,
  kFADErrorStorageError = 5,
  kFADErrorInternalError = 6,
  kFADErrorUnsupportedOsVersion = 7,
  kFADErrorInvalidState = 8,
  kFADErrorBadSlotId = 9,
  kFADErrorSuppressed = 10,
  kFADErrorContentUnavailable = 11,
  kFADErrorPlayerError = 12
} FADErrorCode;

typedef enum: NSInteger {
  kFADFormatInterstitialLandscape = 1, // until ver.20180420
  kFADFormatInterstitialPortrait = 2,  // until ver.20180420
  kFADFormatInFeed = 3,
  kFADFormatBounce = 4,                // until ver.20200625
  kFADFormatW320H180 = 5,
  kFADFormatW300H250 = 6,              // not available
  kFADFormatCustomLayout = 7,
  kFADFormatVideoReward = 8            // use this for interstitial too since ver.20180601
} FADFormat;

typedef enum: NSInteger {
  kFADStateNotLoaded = 1,
  kFADStateLoading = 2,
  kFADStateLoaded = 3,
  // kFADStateShowing = 4,             // until ver.20190311
  kFADStateClosed = 5,
  kFADStateError = 6
} FADState;

typedef enum: NSInteger {
  kFADCreativeTypeNotLoaded = 0, // only returns when called before a successful load.
  kFADCreativeTypeMovie = 1,
  kFADCreativeTypeImage = 2,
} FADCreativeType;

typedef NS_ENUM (NSInteger, FADAdAgeRating) {
  kFADAdAgeRatingUnspecified = 0,
  kFADAdAgeRatingAllAge = 1,
  kFADAdAgeRatingAge13AndOver = 2,
  kFADAdAgeRatingAge15AndOver = 3,
  kFADAdAgeRatingAge18AndOver = 4
};

typedef NS_ENUM (NSInteger, FADNeedGdprNonPersonalizedAdsTreatment) {
  kFADNeedGdprNonPersonalizedAdsTreatmentUnspecified = 0,
  kFADNeedGdprNonPersonalizedAdsTreatmentFalse = 1,
  kFADNeedGdprNonPersonalizedAdsTreatmentTrue = 2
};

typedef NS_ENUM (NSInteger, FADNeedChildDirectedTreatment) {
  kFADNeedChildDirectedTreatmentUnspecified = 0,
  kFADNeedChildDirectedTreatmentFalse = 1,
  kFADNeedChildDirectedTreatmentTrue = 2
};

static NSString* const kFADConfigAppIdKey = @"FIVE_APP_ID";
static NSString* const kFADConfigAdFormatKey = @"FIVE_AD_FORMATS";
static NSString* const kFADConfigIsTestKey = @"FIVE_IS_TEST";

/******************************************************************************
 * FADConfig
 ******************************************************************************/
@interface FADConfig : NSObject

+ (FADConfig*) loadFromInfoDictionary;

- (id)initWithAppId:(NSString *)appId;

@property (nonatomic,readonly) NSString *appId;
@property (nonatomic) NSSet *fiveAdFormat;

@property (nonatomic) FADAdAgeRating maxAdAgeRating;  // default is kFADAdAgeRatingUnspecified
@property (nonatomic) FADNeedGdprNonPersonalizedAdsTreatment needGdprNonPersonalizedAdsTreatment;  // default is kFADNeedGdprNonPersonalizedAdsTreatmentUnspecified
@property (nonatomic) FADNeedChildDirectedTreatment needChildDirectedTreatment;  // default is kFADNeedChildDirectedTreatmentUnspecified

@property (nonatomic) BOOL isTest; // NO by default.
@end

/******************************************************************************
 * FADMediaUserAttribute
 ******************************************************************************/
@interface FADMediaUserAttribute : NSObject
- (id)initWithKey:(NSString *)key value:(NSString *)value;
@property (nonatomic,readonly) NSString *key;
@property (nonatomic,readonly) NSString *value;
@end


/******************************************************************************
 * FADSettings
 ******************************************************************************/
@interface FADSettings : NSObject
- (id)init __attribute__((unavailable("init is not available. use sharedInstanceWithConfig.")));

// Please call this method first.
// Calling this method multiple times with same configuration is valid.
+ (void)registerConfig:(FADConfig *)config;

// Once registerConfig is called with valid config argument, this returns true.
+ (BOOL)isConfigRegistered;

// enabled by default.
+ (void)enableSound:(BOOL)enabled;
+ (BOOL)isSoundEnabled;

+ (NSString *)version;
+ (NSString *)semanticVersion;

// setup WKUserContentController to show web page ads within WKWebView.
+ (void)setupFADWKWebViewHelperScript:(WKUserContentController *)controller __attribute__((deprecated("WebView feature is deprecated. We might delete this API in a future release.")));

+ (void)setMediaUserAttributes:(NSArray<FADMediaUserAttribute*> *)attributes;
@end

/******************************************************************************
 * Ad Objects.
 ******************************************************************************/
@protocol FADAdInterface <NSObject>
- (void)loadAd;

// default value is FADSettings's isSoundEnabled.
- (void)enableSound:(BOOL)enabled;
- (BOOL)isSoundEnabled;

@property (nonatomic, weak) id<FADDelegate> delegate;
@property (nonatomic, readonly) NSString *slotId;
@property (nonatomic, readonly) FADState state;
@property (nonatomic, readonly) FADCreativeType creativeType;

// Media developer can use this property for distinguishing each ad object.
// This property is not used for reporting. SDK does not read/write this property.
@property (nonatomic) NSString* fiveAdTag;

// PLEASE DON'T USE FOLLOWING METHODS until Five's dev-rel specified to do so...
- (NSString *)getAdParameter;
@end

@interface FADInterstitial: NSObject<FADAdInterface>
- (instancetype)initWithSlotId:(NSString *)slotId;
- (instancetype)init __attribute__((unavailable("init is not available")));

// Default timeout interval is 10 seconds.
// If a timeout occurs, it returns as a kFADErrorNetworkError.
- (void)loadAdAsync;
- (void)loadAdAsyncWithTimeoutInterval:(NSTimeInterval)timeout;

- (BOOL)show;
@end

__attribute__((deprecated("W320H180 ad format is deprecated. We might delete this API in a future release. Use CustomLayout ad format and FADAdViewCustomLayout instead.")))
@interface FADAdViewW320H180: UIView<FADAdInterface>
- (instancetype)initWithFrame:(CGRect)frame slotId:(NSString *)slotId;
- (instancetype)init __attribute__((unavailable("init is not available")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder is not available")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame is not available")));

// Only available after ad is loaded.
// This may returns empty string e.g. @""
- (NSString *)getAdvertiserName;
@end

__attribute__((deprecated("InFeed ad format is deprecated. We might delete this API in a future release. Use CustomLayout ad format and FADAdViewCustomLayout instead.")))
@interface FADInFeed: UIView<FADAdInterface>
// height will changed when loadAd is completed.
- (instancetype)initWithSlotId:(NSString *)slotId width:(float)width;
- (instancetype)init __attribute__((unavailable("init is not available")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder is not available")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame is not available")));
@end

@interface FADAdViewCustomLayout: UIView<FADAdInterface>
- (instancetype)initWithSlotId:(NSString *)slotId width:(float)width;
- (instancetype)init __attribute__((unavailable("init is not available")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder is not available")));
- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable("initWithFrame is not available")));

// Default timeout interval is 10 seconds.
// If a timeout occurs, it returns as a kFADErrorNetworkError.
- (void)loadAdAsync;
- (void)loadAdAsyncWithTimeoutInterval:(NSTimeInterval)timeout;

// Only available after ad is loaded.
// This may returns empty string e.g. @""
- (NSString *)getAdvertiserName;
@end

// PLEASE DON'T USE FOLLOWING FEATURE unless Five's dev-rel specified to do so...
@interface FADVideoReward: NSObject<FADAdInterface>
- (instancetype)initWithSlotId:(NSString *)slotId;
- (instancetype)init __attribute__((unavailable("init is not available")));

// Default timeout interval is 10 seconds.
// If a timeout occurs, it returns as a kFADErrorNetworkError.
- (void)loadAdAsync;
- (void)loadAdAsyncWithTimeoutInterval:(NSTimeInterval)timeout;

- (BOOL)show;
@end

@interface FADNative: NSObject<FADAdInterface>
- (instancetype)initWithSlotId:(NSString *)slotId videoViewWidth:(float)videoViewWidth;
- (instancetype)init __attribute__((unavailable("init is not available")));

// Default timeout interval is 10 seconds.
// If a timeout occurs, it returns as a kFADErrorNetworkError.
- (void)loadAdAsync;
- (void)loadAdAsyncWithTimeoutInterval:(NSTimeInterval)timeout;

// The methods below are only available after ad is loaded.
- (void) registerViewForInteraction:(UIView*)nativeAdView
            withInformationIconView:(UIView*)informationIconView
                 withClickableViews:(NSArray<UIView*>*)clickableViews;

- (UIView*)getAdMainView;

// return values are non-nil, but NSString may be empty string e.g. @""
- (NSString*)getButtonText;
- (NSString*)getDescriptionText;
- (NSString*)getAdvertiserName;
- (NSString*)getAdTitle;

- (void) loadIconImageAsyncWithBlock:(void (^) (UIImage*))block;
- (void) loadInformationIconImageAsyncWithBlock:(void (^) (UIImage*))block;
@end

/******************************************************************************
 * FADDelegate
 ******************************************************************************/
@protocol FADDelegate <NSObject>

@required
- (void)fiveAdDidLoad:(id<FADAdInterface>)ad;
- (void)fiveAd:(id<FADAdInterface>)ad didFailedToReceiveAdWithError:(FADErrorCode) errorCode;

@optional
- (void)fiveAdDidClick:(id<FADAdInterface>)ad;
- (void)fiveAdDidClose:(id<FADAdInterface>)ad;
- (void)fiveAdDidStart:(id<FADAdInterface>)ad;
- (void)fiveAdDidPause:(id<FADAdInterface>)ad;
- (void)fiveAdDidResume:(id<FADAdInterface>)ad;
- (void)fiveAdDidViewThrough:(id<FADAdInterface>)ad;
- (void)fiveAdDidReplay:(id<FADAdInterface>)ad;
- (void)fiveAdDidStall:(id<FADAdInterface>)ad;
- (void)fiveAdDidRecover:(id<FADAdInterface>)ad;
- (void)fiveAdDidImpressionImage:(id<FADAdInterface>)ad;
@end
