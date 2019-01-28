//
//  GlossomAds.h
//  GlossomAds
//
//  Created by Xiaofan Dai on 1/15/16.
//  Copyright © 2016年 Glossom, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//! Project version number for GlossomAds.
FOUNDATION_EXPORT double GlossomAdsVersionNumber;

//! Project version string for GlossomAds.
FOUNDATION_EXPORT const unsigned char GlossomAdsVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <GlossomAds/PublicHeader.h>


/**
 *  GlossomAdsDelegate
 *
 *  Use the GlossomAdsDelegate to receive callbacks when ad availability changes.
 */
@protocol GlossomAdsDelegate <NSObject>

@optional

/**
 *  Notifies your app of real-time updates about ad availability changes.
 *
 *  @param available Whether ads became available or unavailable.
 *  @param zoneId    The affected zone.
 */
- (void)onAdAvailabilityChange:(BOOL)available inZone:(nonnull NSString *)zoneId;

@end

/**
 *  GlossomAdsVideoAdDelegate
 *
 *  Use the GlossomAdsVideoAdDelegate to receive callbacks when
 *  ads start playing or when an attempt to play an ad has finished (successfully or not).<br />
 *  This is most frequently used to implement pausing of an app's sound and music.
 */
@protocol GlossomAdsVideoAdDelegate <NSObject>

@optional

/**
 *  Notifies your app that an ad will actually play in response to the app's request to play an ad.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsVideoStartPlay:(nonnull NSString *)zoneId;

/**
 *   Notifies your app that an ad skipped playing.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsVideoSkip:(nonnull NSString *)zoneId;

/**
 *  Notifies your app that an ad paused playing.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsVideoPause:(nonnull NSString *)zoneId;

/**
 *  Notifies your app that an ad resumed playing.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsVideoResume:(nonnull NSString *)zoneId;

/**
 *   Notifies your app that an ad completed playing and control has been returned to the app.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsVideoFinish:(nonnull NSString *)zoneId;

@end

/**
 *  GlossomAdsInterstitialAdDelegate
 */
@protocol GlossomAdsInterstitialAdDelegate <GlossomAdsVideoAdDelegate>

@optional

/**
 *  Notifies your app that an Interstitial ad will be showed.
 *
 *  @param zoneId The affected zone.
 */
- (void)onGlossomAdsAdShow:(nonnull NSString *)zoneId;

/**
 *  Notifies your app that an Interstitial ad will be closed and control has been returned to the app.
 *
 *  @param zoneId The affected zone.
 *  @param shown A boolean indicating whether ad is shown.
 */
- (void)onGlossomAdsAdClose:(nonnull NSString *)zoneId isShown:(BOOL)shown;

@end

/**
 *  GlossomAdsRewardAdDelegate
 */
@protocol GlossomAdsRewardAdDelegate <GlossomAdsInterstitialAdDelegate>

@optional

/**
 *  Notifies your app that an Reward ad will be reward.
 *
 *  @param zoneId  The affected zone.
 *  @param success A boolean indicating whether reward transaction is succeed or failed.
 */
- (void)onGlossomAdsReward:(nonnull NSString *)zoneId success:(BOOL)success;

@end

/**
 *  GlossomBillboardAdDelegate
 */
@protocol GlossomBillboardAdDelegate <GlossomAdsInterstitialAdDelegate>
@end

/**
 GlossomAds's processes status for the zone.

 - GlossomAdsZoneStatusActive: All processes are active.
 - GlossomAdsZoneStatusInactive: All processes are inactive.
 - GlossomAdsZoneStatusUndefined: The zone status is undefined. Make sure the zone is configured.
 */
typedef NS_ENUM(NSInteger, GlossomAdsZoneStatus) {
  GlossomAdsZoneStatusActive,
  GlossomAdsZoneStatusInactive,
  GlossomAdsZoneStatusUndefined
};

/**
  BillboardAd's position when the app is Portrait
 
 - GlossomBillBoardAdLayoutVerticalBottom: show on the Bottom.
 - GlossomBillBoardAdLayoutVerticalBottom: show in the Middle.
 - GlossomBillBoardAdLayoutVerticalBottom: show on the Top.
 */
typedef NS_ENUM(NSInteger, GlossomBillBoardAdLayoutVertical) {
  GlossomBillBoardAdLayoutVerticalBottom,
  GlossomBillBoardAdLayoutVerticalMiddle,
  GlossomBillBoardAdLayoutVerticalTop
};

/**
 BillboardAd's position when the app is Landscape
 
 - GlossomBillBoardAdLayoutVerticalBottom: show on the Left.
 - GlossomBillBoardAdLayoutVerticalBottom: show in the Middle.
 - GlossomBillBoardAdLayoutVerticalBottom: show on the Right.
 */
typedef NS_ENUM(NSInteger, GlossomBillBoardAdLayoutHorizontal) {
  GlossomBillBoardAdLayoutHorizontalLeft,
  GlossomBillBoardAdLayoutHorizontalMiddle,
  GlossomBillBoardAdLayoutHorizontalRight
};

/**
 *  GlossomAds
 */
@interface GlossomAds : NSObject

/**
 *  Assigns your own custom identifier to the current app user.
 *
 *  @param identifier An arbitrary, application-specific identifier string for the current user.
 */
+ (void)setUserIdentifier:(nonnull NSString *)identifier;

/**
 *  Returns the device’s current custom identifier.
 *
 *  @return The custom identifier string most recently set using setCustomID.
 */
+ (nullable NSString *)getUserIdentifier;

/**
 *  Assigns user attribute as int value
 *
 *  @param value user attribute value
 *  @param key user attribute key name
 */
+ (void)setUserAttributeAsInt:(int)value forKey:(nonnull NSString *)key;

/**
 *  Assigns user attribute as Long value
 *
 *  @param value user attribute value
 *  @param key user attribute key name
 */
+ (void)setUserAttributeAsLong:(long)value forKey:(nonnull NSString *)key;

/**
 *  Assigns user attribute as double value
 *
 *  @param value user attribute value
 *  @param key user attribute key name
 */
+ (void)setUserAttributeAsDouble:(double)value forKey:(nonnull NSString *)key;

/**
 *  Assigns user attribute as boolean value
 *
 *  @param value user attribute value
 *  @param key user attribute key name
 */
+ (void)setUserAttributeAsBoolean:(BOOL)value forKey:(nonnull NSString *)key;

/**
 *  Assigns user attribute
 *
 *  @param value user attribute value
 *  @param key user attribute key name
 */
+ (void)setUserAttributeAsString:(nonnull NSString *)value forKey:(nonnull NSString *)key;

/**
 *  Returns current user attribute.
 *
 *  @return The custom identifier string most recently set using setCustomID.
 *  @param key user attribute key name.
 */
+ (nullable id)userAttributeForKey: (nonnull NSString *)key;

/**
 Set client option value for key.

 @param key client option key
 @param value client option value. Set nil in case you want to unset.
 @param zoneId zone ID where option will be set
 */
+ (void)setClientOption:(nonnull NSString *)key value:(nullable NSString *)value forZone:(nullable NSString *)zoneId;

/**
 *  Configures GlossomAds specifically for your app; required for usage of the rest of the API.
 *
 *  @param appId         The GlossomAds app ID for your app. This can be created and retrieved by Glossom,Inc.
 *  @param zoneIds       An array of at least one GlossomAds zone ID string. GlossomAds zone IDs can be created and retrieved by Glossom,Inc.
 *  @param delegate      The delegate to receive ad availability events. Can be nil for apps that do not need these events.
 *  @param clientOptions TODO
 */
+ (void)configure:(nonnull NSString *)appId zoneIds:(nonnull NSArray *)zoneIds delegate:(nullable id <GlossomAdsDelegate>)delegate clientOptions:(nullable NSDictionary *)clientOptions;

/**
 Configures GlossomAds specifically for your app; required for usage of the rest of the API.

 @param appId The GlossomAds app ID for your app. This can be created and retrieved by Glossom,Inc.
 @param zoneIds An array of at least one GlossomAds zone ID string. GlossomAds zone IDs can be created and retrieved by Glossom,Inc.
 @param clientOptions A dictionary of optional request parameter for GlossomAds.
 */
+ (void)configure:(nonnull NSString *)appId zoneIds:(nonnull NSArray<NSString *> *)zoneIds clientOptions:(nullable NSDictionary *)clientOptions;

/**
 Start requesting GlossomAds.

 @param zoneIds The array of affected zones.
 */
+ (void)startWithZoneIds:(nonnull NSArray<NSString *> *)zoneIds;

/**
 Stop requesting GlossomAds.

 @param zoneIds The array of affected zones.
 */
+ (void)stopWithZoneIds:(nonnull NSArray<NSString *> *)zoneIds;

/**
 Set the delegagate object which receives ad availability events. (DEPRECATED)

 @param delegate The delegate to receive ad availability events. Can be nil for apps that do not need these events.
 */
+ (void)setDelegate:(nonnull id <GlossomAdsDelegate>)delegate __deprecated_msg("Please use 'setDelegate:forZone:' instead.");

/**
 Set the delegagate object which receives ad availability events for specific zone.

 @param delegate The delegate to receive ad availability events.
 @param zoneId The affected zone.
 */
+ (void)setDelegate:(nullable id <GlossomAdsDelegate>)delegate forZone:(nonnull NSString *)zoneId;

/**
 *  Plays an GlossomAds ad.
 *
 *  @param zoneId   The zone from which the ad should play.
 *  @param delegate The delegate to receive ad events. Can be nil for apps that do not need these events.
 */
+ (void)showVideo:(nonnull NSString *)zoneId delegate:(nullable id <GlossomAdsInterstitialAdDelegate>)delegate;

/**
 *  Plays an GlossomAds reward ad.
 *
 *  @param zoneId   The zone from which the ad should play.
 *  @param delegate The delegate to receive ad events. Can be nil for apps that do not need these events.
 */
+ (void)showRewardVideo:(nonnull NSString *)zoneId delegate:(nullable id <GlossomAdsRewardAdDelegate>)delegate;

/**
 *  Returns the zone status for the specified zone.
 *
 *  @param zoneId The zone in question.
 *
 *  @return A boolean indicating whether a zone is currently available for the user.
 */
+ (BOOL)isReady:(nonnull NSString *)zoneId;

/**
 *  Returns whether an ad is currently being played.
 *
 *  @return A boolean indicating if GlossomAds is currently playing an ad.
 */
+ (BOOL)isCurrentlyPlayingAd;

/**
 Add test device. Only test ads will be delivered to the device.

 @param deviceId A string indicating your device ID.
 */
+ (void)addTestDevice:(nonnull NSString *)deviceId;

/**
 Returns current process status for specific zone.

 @param zoneId The zone in question.
 @return Current status for the zone.
 */
+ (GlossomAdsZoneStatus)getZoneStatus:(nonnull NSString *)zoneId;

/**
 *  Plays an GlossomAds BillboardAd.
 *
 *  @param zoneId   The zone from which the ad should play.
 *  @param delegate The delegate to receive ad events. Can be nil for apps that do not need these events.
 */
+ (void)showBillboardAd:(nonnull NSString *)zoneId delegate:(nullable id <GlossomBillboardAdDelegate>)delegate;

/**
 *  Plays an GlossomAds BillboardAd.
 *
 *  @param zoneId            The zone from which the ad should play.
 *  @param delegate          The delegate to receive ad events. Can be nil for apps that do not need these events.
 *  @param layoutVertical    The ad's position when the app is Portrait. (Bottom, Middle, Top)
 *  @param layoutHorizontal  The ad's position when the app is Landscape. (Left, Middle, Right)
 */
+ (void)showBillboardAd:(nonnull NSString *)zoneId delegate:(nullable id <GlossomBillboardAdDelegate>)delegate layoutVertical:(GlossomBillBoardAdLayoutVertical)layoutVertical layoutHorizontal:(GlossomBillBoardAdLayoutHorizontal)layoutHorizontal;

/**
 *  Forced-shutdown an GlossomAds BillboardAd.
 *  No need to call it usually.
 */
+ (void)closeBillboardAd;

@end

@protocol GlossomNativeAdDelegate;

/**
 *  GlossomAdsNativeAd
 *
 *  GlossomAds Native ad.
 */
@interface GlossomAdsNativeAd : NSObject

@property (nonatomic, weak, nullable) id<GlossomNativeAdDelegate> delegate;
@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *zoneId;
@property (nonatomic, copy, nullable) NSString *title;

- (instancetype)init __unavailable;

/**
 *  Initialize a Native ad with zoneId
 *
 *  @param zoneId   The zone from which the ad should play.
 */
- (instancetype)initWithZoneId:(NSString *)zoneId;

/**
 *  Load a Native ad.
 */
- (void)loadAd;

/**
 *  Set up the mediaview just before you like to show the ad
 */
- (void)setupMediaView;

/**
 *  Get the mediaview and add it to the view you like to show the Native ad.
 *  If you did not call setupMediaView before, the mediaview will be nil.
 */
- (nullable UIView *)getMediaView;

/**
 *  Play the Native Ad.
 *  If you did not call setupMediaView before, will be fail.
 */
- (void)playMediaView;

@end

/**
 *  GlossomNativeAdDelegate
 *
 *  Use the GlossomNativeAdDelegate to receive callbacks when
 *  Native ads didload or not.
 */
@protocol GlossomNativeAdDelegate <NSObject>
@optional
/**
 *  Notifies your app that an Native ad did load.
 *
 *  @param nativeAd Use this instant to show nativeAd.
 */
- (void)onGlossomNativeAdDidLoad:(nonnull GlossomAdsNativeAd *)nativeAd;

/**
 *  Notifies your app that it failed to load a Native Ad.
 *  There is nothing you can do besides try it again later.
 *
 *  @param error Show error message.
 */
- (void)onGlossomNativeAdDidFailWithError:(nullable NSError *)error;

/**
 *  Notifies your app that a Native ad will actually play.
 */
- (void)onGlossomNativeAdDidStartPlaying;

/**
 *  Notifies you app that a Native ad play has been completed.
 */
- (void)onGlossomNativeAdDidFinishPlaying;

/**
 *  Notifies your app that an error occurred when playing.
 */
- (void)onGlossomNativeAdPlayWithError:(nullable NSError *)error;
@end
