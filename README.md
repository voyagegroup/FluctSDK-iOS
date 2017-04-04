# FluctSDK

## Installation

FluctSDK は [CocoaPods](http://cocoapods.org) から利用可能です

利用するプロジェクトの`Podfile`に下記の記述を追加して下さい

```ruby
use_frameworks!

pod "FluctSDK"
```

## APIドキュメント
FluctSDK-iOSの[Wiki](https://github.com/voyagegroup/FluctSDK-iOS/wiki)を参照してください

# FluctSDK Release Note

## v4.5.0 2017/04/04
* サポートバージョンをiOS7.0以上に変更
* FSSBannerViewのコールバックの種類を追加
  * loadFinish: 広告情報の読み込み完了時の通知
  * noAd: 表示する広告が存在しない時の通知

## v4.4.3 2017/01/25
* UITableViewにバナー広告を実装したサンプルコード及びドキュメントの追加

## v4.4.2 2016/11/08
* 名前衝突対策のため一部定数名を変更

## v4.4.1 2016/10/27
* デバッグ情報取得効率化のため, 内部処理を変更

## v4.4.0 2016/09/29
* 端末の画面サイズに合わせて調整された大きさのバナー広告を表示する機能を持ったクラスの追加
* FluctBannerView（旧バナー広告クラス）, FluctInterstitialView（旧インタースティシャル広告クラス）を非推奨に変更
* ドキュメントをGitHubのWikiに移行

## v4.3.7 2016/09/12
* ライフサイクルメソッドに関連した不具合修正
* FluctBannerView のインタフェイス一部変更

## v4.3.6 2016/08/04
* Swiftのサンプルコード及びサンプルプロジェクトを追加

## v4.3.5 2016/06/27
* サポートバージョンをiOS6.0以上に変更

## v4.3.4 2016/05/17
* IPv6 Only Networkに正式対応

## v4.3.3 2016/04/26
* Bitcodeに対応
* modulecacheのwarningが出てしまうバグの修正

## v4.3.2 2016/01/20
* Swiftプロジェクト時のCocoaPods利用でうまくImport出来ないバグの修正

## v4.3.1 2016/01/13
* CocoaPodsに対応
* SDKをframework化

## v4.3.0 以前の変更点について
* [改版履歴](https://github.com/voyagegroup/FluctSDK-iOS/wiki/%E6%94%B9%E7%89%88%E5%B1%A5%E6%AD%B4)をご確認下さい

## LICENSE
Copyright fluct, Inc. All rights reserved.
