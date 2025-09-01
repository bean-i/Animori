# 🎬 Animori  
> 多様なアニメ作品を探索し、自分だけのアニメ図鑑を作れる iOS アプリ  

- **開発期間**: 2025年3月27日〜2025年4月12日（約2週間）  
- **開発形態**: 個人開発  

## ✅ 主な機能  
**1. アニメ探索**  
- 人気、シーズン別、完結、劇場版、ジャンル別のリストを表示  

**2. 検索機能**  
- キーワード検索  
- 最近の検索ワード保存  

**3. 詳細情報の提供**  
- アニメ／キャラクターの詳細情報を表示  

**4. 多言語翻訳対応**  
- あらすじやキャラクター紹介をシステム言語に基づいて自動翻訳  

**5. マイアニメ図鑑**  
- 視聴状況（視聴中／視聴予定／視聴完了）に応じて作品を保存・管理  

## 💻 技術スタック  
- **言語**: `Swift`  
- **UI**: `UIKit`（一部 `SwiftUI` を `UIHostingController` で組み込み）  
- **アーキテクチャ**: `MVVM`, `Repository`, `DIContainer`, `Input/Output パターン`  
- **非同期処理**: `RxSwift`, `RxCocoa`, `ReactorKit`, `OperationQueue`, `Actor`  
- **ネットワーク**: `URLSession + async/await`  
- **データベース**: `Realm`  
- **多言語対応**: `Apple Translate API`, `String Catalog`  
- **外部ライブラリ**: `RxDataSources`, `SnapKit`, `FSPagerView`, `Floaty`, `Toast`  

## 🔎 工夫した点  
### 1. APIリクエスト構成と非同期処理の管理  
- Swift Concurrencyベースの `Task` を `OperationQueue` で実行可能にするため、独自の `AsyncOperation` を実装  
- `Actor` ベースの **トークンバケットアルゴリズム** でリクエスト速度を制御し、**スレッドセーフな非同期環境** を構成  

### 2. ネットワークデータ層の分離  
- APIレスポンスモデルを `DTO → Entity` へ変換し、Viewに依存しない構造に分離  
- **プロトコル指向設計** によりドメインモデルを抽象化し、**テスト容易性** を高め、**ViewModelとの結合度を低減**  

### 3. Reactorパターンに基づく状態管理  
- **ReactorKit + RxSwift** を用い、`Action → Mutation → State` の単方向データフローを実現  
- 画面ごとに専用の **Reactorクラス** を設計し、**非同期イベントとUI更新の連携** を効率化  

### 4. 多言語翻訳とローカライズ  
- **Apple Translate API** によりシステム言語に基づいた **自動翻訳** を実現  
- `String Catalog` ベースで **国際化対応構成** を設計  

### 5. 画像キャッシュとセル内非同期制御  
- `NSCache` を利用したメモリベースの **画像キャッシュシステム** でリクエストを最小化し、**スクロール性能を最適化**  
- TableView／CollectionViewセル内で非同期画像読み込み `Task` を管理し、再利用時に `cancel()` を明示的に呼び出して、**ちらつきやメモリリークを防止**  

## 📷 画面  
| ホーム | 検索 | アニメ詳細 | キャラクター詳細 | 図鑑 |
|:--:|:--:|:--:|:--:|:--:|
| <img alt="홈" src="https://github.com/user-attachments/assets/e3fd1837-f0fe-4779-9b74-2f2e0b7602aa" />　| <img alt="검색 화면" src="https://github.com/user-attachments/assets/4d10c13c-5ad1-43d6-bcf3-7624e5e6b9e6" /> | <img alt="애니 상세" src="https://github.com/user-attachments/assets/99285d01-7af0-4d8a-a328-7aec698493bb" /> | <img alt="캐릭터 상세" src="https://github.com/user-attachments/assets/648380a7-ef12-4f37-be3b-97d174273353" /> | <img alt="보관함" src="https://github.com/user-attachments/assets/60ceb8a7-9b79-437e-87bd-d41c24e1d9b3" /> |
