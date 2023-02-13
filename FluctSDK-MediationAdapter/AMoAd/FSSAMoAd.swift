//
//  FSSAMoAd.swift
//  FluctSDKApp
//
//  Copyright © 2022 fluct, Inc. All rights reserved.
//

import Foundation

#if canImport(AMoAd)

import AMoAd

/// 広告受信結果
@objc public enum FSSAMoAdResult: Int {
    /// 成功
    case success
    /// 失敗
    case failure
    /// 配信する広告が無い
    case empty
    /// エラー不明
    case unknown

    fileprivate static func convert(_ value: AMoAdResult) -> FSSAMoAdResult {
        switch value {
        case .success:
            return .success
        case .failure:
            return .failure
        case .empty:
            return .empty
        default:
            return .unknown
        }
    }
}

/// インタースティシャル動画広告
@objc public class FSSAMoAdInterstitialVideo: NSObject {
    fileprivate var amoadInterstitialVideo: AMoAdInterstitialVideo!

    /// AMoAd SDKのコールバックをFSSAMoAdInterstitialVideoDelegateに流すブリッジ
    fileprivate var delegateBridge: FSSAMoAdInterstitialVideoDelegateBridge
    @objc weak public var delegate: FSSAMoAdInterstitialVideoDelegate? {
        didSet {
            self.delegateBridge.target = self.delegate
        }
    }

    /// 広告のロードが完了していれば true
    @objc public var isLoaded: Bool {
        get {
            return self.amoadInterstitialVideo.isLoaded
        }
    }

    /// 動画の再生中にユーザが×ボタンをタップして広告を閉じることを許可するか
    @objc public var isCancellable: Bool {
        get {
            return self.amoadInterstitialVideo.isCancellable
        }
        set {
            self.amoadInterstitialVideo.isCancellable = newValue
        }
    }

    @objc public init(sid: String) {
        amoadInterstitialVideo = AMoAdInterstitialVideo.shared(sid: sid, tag: "")
        delegateBridge = FSSAMoAdInterstitialVideoDelegateBridge()
        amoadInterstitialVideo.delegate = delegateBridge
        super.init()
        delegateBridge.interstitial = self
    }

    /// AMoAdがインストールされていれば true
    @objc public static func isAMoAdActive() -> Bool {
        return true
    }

    /// 広告をロードする
    @objc public func load() {
        self.amoadInterstitialVideo.load()
    }

    /// 広告を表示する
    @objc public func show() {
        self.amoadInterstitialVideo.show()
    }

    /// 広告を閉じる
    @objc public func dismiss() {
        self.amoadInterstitialVideo.dismiss()
    }
}

/// FSSAMoAdInterstitialVideoDelegateBridgeはAMoAd SDKのコールバックをtargetにブリッジする
/// FSSAMoAdInterstitialVideoはobjcアノテーションがあるので、swiftで実装されたAMoAdInterstitialVideoDelegateが利用できないためにこのクラスは存在する
private class FSSAMoAdInterstitialVideoDelegateBridge: AMoAdInterstitialVideoDelegate {
    weak var target: FSSAMoAdInterstitialVideoDelegate?
    weak var interstitial: FSSAMoAdInterstitialVideo?

    /// 広告のロードが完了した
    func amoadInterstitialVideoDidLoadAd(amoadInterstitialVideo: AMoAdInterstitialVideo, result: AMoAdResult) {
        self.target?.amoadInterstitialVideoDidLoadAd?(amoadInterstitialVideo: self.interstitial!, result: FSSAMoAdResult.convert(result))
    }

    /// 動画の再生を開始した
    func amoadInterstitialVideoDidStart(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoDidStart?(amoadInterstitialVideo: self.interstitial!)
    }

    /// 動画を最後まで再生完了した
    func amoadInterstitialVideoDidComplete(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoDidComplete?(amoadInterstitialVideo: self.interstitial!)
    }

    /// 動画の再生に失敗した
    func amoadInterstitialVideoDidFailToPlay(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoDidFailToPlay?(amoadInterstitialVideo: self.interstitial!)
    }

    /// 広告を表示した
    func amoadInterstitialVideoDidShow(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoDidShow?(amoadInterstitialVideo: self.interstitial!)
    }

    /// 広告を閉じた
    func amoadInterstitialVideoWillDismiss(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoWillDismiss?(amoadInterstitialVideo: self.interstitial!)
    }

    /// 広告をクリックした
    func amoadInterstitialVideoDidClickAd(amoadInterstitialVideo: AMoAdInterstitialVideo) {
        self.target?.amoadInterstitialVideoDidClickAd?(amoadInterstitialVideo: self.interstitial!)
    }
}

#else

/// ダミーインターフェイス
/// 広告受信結果
@objc public enum FSSAMoAdResult: Int {
    /// 成功
    case success
    /// 失敗
    case failure
    /// 配信する広告が無い
    case empty
    /// エラー不明
    case unknown
}

/// インタースティシャル動画広告
@objc public class FSSAMoAdInterstitialVideo: NSObject {

    @objc weak public var delegate: FSSAMoAdInterstitialVideoDelegate?

    /// 広告のロードが完了していれば true
    @objc public var isLoaded: Bool {
        return false
    }

    /// 動画の再生中にユーザが×ボタンをタップして広告を閉じることを許可するか
    @objc public var isCancellable: Bool {
        return false
    }

    @objc public init(sid: String) {
        super.init()
    }

    /// AMoAdがインストールされていれば true
    @objc public static func isAMoAdActive() -> Bool {
        return false
    }

    /// 広告をロードする
    @objc public func load() {}

    /// 広告を表示する
    @objc public func show() {}

    /// 広告を閉じる
    @objc public func dismiss() {}
}

#endif

/// インタースティシャルAfiOデレゲート
@objc public protocol FSSAMoAdInterstitialVideoDelegate: AnyObject {

    /// 広告のロードが完了した
    @objc optional func amoadInterstitialVideoDidLoadAd(amoadInterstitialVideo: FSSAMoAdInterstitialVideo, result: FSSAMoAdResult)

    /// 動画の再生を開始した
    @objc optional func amoadInterstitialVideoDidStart(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)

    /// 動画を最後まで再生完了した
    @objc optional func amoadInterstitialVideoDidComplete(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)

    /// 動画の再生に失敗した
    @objc optional func amoadInterstitialVideoDidFailToPlay(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)

    /// 広告を表示した
    @objc optional func amoadInterstitialVideoDidShow(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)

    /// 広告を閉じた
    @objc optional func amoadInterstitialVideoWillDismiss(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)

    /// 広告をクリックした
    @objc optional func amoadInterstitialVideoDidClickAd(amoadInterstitialVideo: FSSAMoAdInterstitialVideo)
}
