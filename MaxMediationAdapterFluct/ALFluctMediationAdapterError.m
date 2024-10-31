//
//  ALFluctMediationAdapterError.m
//  MaxMediationAdapterFluct
//
//

#import "ALFluctMediationAdapterError.h"
@import FluctSDK;

@implementation ALFluctMediationAdapterError

+ (MAAdapterError *)maxErrorFromFluctAdViewError:(NSError *)error {

    NSInteger fluctErrorCode = error.code;
    MAAdapterError *adapterError = MAAdapterError.unspecified;
    switch (fluctErrorCode) {
    case FSSAdViewErrorNoAds:
        adapterError = MAAdapterError.noFill;
        break;
    case FSSAdViewErrorBadRequest:
        adapterError = MAAdapterError.badRequest;
        break;
    case FSSAdViewErrorNotConnectedToInternet:
        adapterError = MAAdapterError.noConnection;
        break;
    case FSSAdViewErrorServerError:
        adapterError = MAAdapterError.serverError;
        break;
    case FSSAdViewErrorUnknown:
    default:
        adapterError = MAAdapterError.unspecified;
        break;
    }

    return [MAAdapterError errorWithAdapterError:adapterError
                        mediatedNetworkErrorCode:fluctErrorCode
                     mediatedNetworkErrorMessage:error.localizedDescription];
}

+ (MAAdapterError *)maxErrorFromFluctVideoError:(NSError *)error {

    NSInteger fluctErrorCode = error.code;
    MAAdapterError *adapterError = MAAdapterError.unspecified;
    switch (fluctErrorCode) {
    case FSSVideoErrorInitializeFailed:
        adapterError = MAAdapterError.notInitialized;
        break;
    case FSSVideoErrorLoadFailed:
    case FSSVideoErrorNotReady:
    case FSSVideoErrorPlayFailed:
        adapterError = MAAdapterError.adNotReady;
        break;
    case FSSVideoErrorNoAds:
        adapterError = MAAdapterError.noFill;
        break;
    case FSSVideoErrorBadRequest:
        adapterError = MAAdapterError.badRequest;
        break;
    case FSSVideoErrorWrongConfiguration:
    case FSSVideoErrorInvalidApp:
        adapterError = MAAdapterError.invalidConfiguration;
        break;
    case FSSVideoErrorNotConnectedToInternet:
        adapterError = MAAdapterError.noConnection;
        break;
    case FSSVideoErrorExpired:
        adapterError = MAAdapterError.adExpiredError;
        break;
    case FSSVideoErrorVastParseFailed:
        adapterError = MAAdapterError.invalidLoadState;
        break;
    case FSSVideoErrorTimeout:
        adapterError = MAAdapterError.timeout;
        break;
    case FSSVideoErrorUnknown:
    default:
        adapterError = MAAdapterError.unspecified;
        break;
    }

    return [MAAdapterError errorWithAdapterError:adapterError
                        mediatedNetworkErrorCode:fluctErrorCode
                     mediatedNetworkErrorMessage:error.localizedDescription];
}

@end
