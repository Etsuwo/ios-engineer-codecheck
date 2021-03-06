# 株式会社ゆめみ iOS エンジニアコードチェック課題

<details><summary>課題概要(Duplicate前に書いてあった内容)</summary>

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の概要を詳しく読んだ上で課題を取り組んでください。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要更新時点では Xcode 13.0）
- Swift：基本最新の安定版（本概要更新時点では Swift 5.5）
- 開発ターゲット：基本最新の安定版（本概要更新時点では iOS 15.0）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |


課題 Issueをご自身のリポジトリーにコピーするGitHub Actionsをご用意しております。  
[こちらのWorkflow](./.github/workflows/copy-issues.yml)を[手動でトリガーする](https://docs.github.com/ja/actions/managing-workflow-runs/manually-running-a-workflow)ことでコピーできますのでご活用下さい。

課題が完成したら、リポジトリーのアドレスを教えてください。

## 参考記事

提出された課題の評価ポイントに関しては、[こちらの記事](https://qiita.com/lovee/items/d76c68341ec3e7beb611)に詳しく書かれてありますので、ぜひご覧ください。

</details>

# 概要

本プロジェクトは株式会社ゆめみ　から出題される iOS エンジニアのインターン課題プロジェクトです。  
課題issueと関連のあるPRは各issueに記載しております。issueをご確認下さい。  

# アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。  
デザインコンセプトは「ハーブ」です。  
また、Githubなどエンジニアリングに関わるサービスやツールは「ゆるさ」が足りないと感じたので全体として「ゆるい」テイストにしました。

| スプラッシュ | 検索画面1 | 検索画面2 | 詳細画面 |
|-|-|-|-|
|<img src="https://user-images.githubusercontent.com/47075496/150277522-3571d2d7-7cdd-4827-9b58-1c389068e3bd.png" width="200"> | <img src="https://user-images.githubusercontent.com/47075496/150277542-08e2b63f-2185-42fb-a7cc-fcb14e375bc2.png" width="200"> | <img src="https://user-images.githubusercontent.com/47075496/150277624-e871b74b-7a89-411d-a321-e00b9a267bf1.png" width="200"> | <img src="https://user-images.githubusercontent.com/47075496/150277637-7f9b46eb-921f-4ef3-95a6-135e6b7e4b46.png" width="200"> |

## 検索画面

- Github上のリポジトリの検索をすることができます
- 検索結果としてセルに以下が表示されます
  - リポジトリ名
  - リポジトリ所有者の名前
  - リポジトリ所有者のアバター画像
  - リポジトリの説明
  - 開発言語
  - 獲得スター
- 検索結果が表示されたCellをタップすることで詳細画面に遷移します
- 検索結果が多い時はページネーションを行います
- 画面を下に引っ張ると検索結果をリフレッシュできます
- 通信エラーが発生した場合、エラー画面を表示します
- 検索結果がゼロ件の場合は、検索結果ゼロ画面を表示します

## 詳細画面

- 検索したGithub上のリポジトリの詳細を確認できます
- リポジトリの詳細として以下が表示されます
  - リポジトリ名
  - リポジトリ所有者の名前
  - リポジトリ所有者のアバター画像
  - リポジトリの説明
  - 開発言語
  - 獲得スター
  - Watcher数
  - Fork数
  - README.md
- 現状、表示されたREADME.md上のリンクは動作しません

## アプリ全体

- iPad、ダークモード非対応

# 環境
## 開発環境  
Xcode: 13.0  
CocoaPods: 1.10.2  
iOS: 15.0

## インストール方法
1. リポジトリをクローンする. 

`git clone git@github.com:Etsuwo/Yumemi-iOS.git`

2. ルートディレクトリにて以下を実行. 

`pod install`

3. プロジェクトファイルを開き実行する. 

# 設計・アーキテクチャ

本アプリケーションではアーキテクチャとしてMVVMを採用している。理由は以下の通りである

- 一部画面をSwiftUIで作成することを見越して相性の良いアーキテクチャを選択したため
- 小規模なアプリケーションであり、FluxやRedexはデメリットの方が目立ってしまうため

また、それぞれの役割は以下の通りである

- View: ViewModelの状態を監視してUIを更新する。また、ユーザからのアクションをViewModelに伝える
- ViewModel: Modelからデータを受け取り自身の状態を更新する。また、ユーザからの入力をModelに伝える
- Model: UIに依存しないロジックやデータの保持を担当する。
  - Repository: 関連するデータをProviderなどから取得する
  - Provider: 関連する通信処理を担う

# ライブラリについて
## 管理方法

- SwiftPackageManagerとCocoaPodsを併用する
- 基本的にはSwiftPackageManagerを使用し、対応していないまたは問題があった場合はCocoaPodsを使用する。

## 利用ライブラリ一覧

- [Alamofire](https://github.com/Alamofire/Alamofire)
- [CombineCocoa](https://github.com/CombineCommunity/CombineCocoa)
- [KingFisher](https://github.com/onevcat/Kingfisher)
- [MarkdownView](https://github.com/keitaoouchi/MarkdownView)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)

# コミットルール
以下の[コミット種別] + 修正内容

- `[add]` 機能やファイル追加
- `[remove]` 機能やファイル削除
- `[fix]` バグ修正
- `[update]` バグでない機能修正
- `[clean]` リファクタ

参考：[Gitのコミットメッセージの書き方](https://qiita.com/itosho/items/9565c6ad2ffc24c09364)

