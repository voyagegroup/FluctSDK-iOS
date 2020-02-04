//
//  FSSInAppBidding.h
//  FluctSDK
//
//  Copyright © 2020 fluct, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * InAppBiddingのレスポンス
 */
@interface FSSInAppBiddingResponse : NSObject

/**
 * biddingした結果の値
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> *value;

@end

/**
 * requestした結果のcallback
 * @param response  bidされた時の情報
 * @param error     エラー情報
 */
typedef void (^FSSInAppBiddingCompletionBlock)(FSSInAppBiddingResponse *_Nullable response, NSError *_Nullable error);

/**
 * biddingするクラス
 */
@interface FSSInAppBidding : NSObject

/**
 * グループID
 */
@property (nonatomic, readonly) NSString *groupId;
/**
 * ユニットID
 */
@property (nonatomic, readonly) NSString *unitId;

/**
 * デバッグモード
 */
@property (nonatomic, readonly, getter=isDebugMode) BOOL debugMode;

/**
 * FSSInAppBiddingの初期化を行う
 * @param groupId   グループID
 * @param unitId    ユニットID
 */
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId;

/**
 * FSSInAppBiddingの初期化を行う
 * @param groupId   グループID
 * @param unitId    ユニットID
 */
- (instancetype)initWithGroupId:(NSString *)groupId unitId:(NSString *)unitId debugMode:(BOOL)debugMode;

/**
 * リクエストする
 * @param completion    リクエスト処理が完了した時にcallされるblock
 */
- (void)requestWithCompletion:(FSSInAppBiddingCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
