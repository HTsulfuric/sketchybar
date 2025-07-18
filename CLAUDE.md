# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリでコードを扱う際のガイダンスを提供します。

## SketchyBar Configuration

これは、Lua スクリプトと C ヘルパープログラムを使用して構築された、包括的な macOS メニューバー設定です。

### コアアーキテクチャ

設定は、モジュラー型の Lua ベース構造に従っています。
- **エントリーポイント** `sketchybarrc` → `helpers/init.lua` → `init.lua`
- **設定フロー** `init.lua` が `bar.lua`、`default.lua`、`items/` の読み込みを調整
- **モジュールシステム** `sketchybarrc` でカスタムパッケージパスを設定した標準 Lua require() を使用

### 主要コンポーネント

**コア設定ファイル**
- `settings.lua` - グローバル設定（フォント、色、寸法、パディング）
- `bar.lua` - メインバーのプロパティ（高さ、位置、背景）
- `colors.lua` - 色の定義とテーマ
- `icons.lua` - SF Symbols を使用したアイコン定義
- `default.lua` - すべてのアイテムのデフォルトスタイル

**アイテムの構成**
- `items/init.lua` - 順番にすべてのバーアイテムを読み込み
- `items/` ディレクトリには個別のアイテム実装が含まれます：
  - `aerospace.lua` - AeroSpace ウィンドウマネージャー統合
  - `apple.lua` - Apple メニュー
  - `menus.lua` - ドロップダウンメニュー
  - `spaces.lua` - ワークスペース/デスクトップインジケータ
  - `front_app.lua` - 現在のアプリケーション表示
  - `calendar.lua` - 日付/時刻表示
  - `widgets/` - システムウィジェット（バッテリー、CPU、音量、WiFi）
  - `media.lua` - Spotify/Apple Music 統合

**ヘルパーシステム**
- `helpers/init.lua` - 起動時に C ヘルパープログラムをコンパイル
- `helpers/makefile` - イベントプロバイダとメニューをビルド
- `helpers/event_providers/` - システム監視用 C プログラム（CPU、ネットワーク）
- `helpers/menus/` - メニュー機能用 C プログラム
- メディアコントロールとモニタリング用のシェルスクリプト

### メディア統合アーキテクチャ

メディアシステムは、カスタム osascript ベースのアプローチを使用しています。
- `helpers/update_media.sh` - Spotify/Apple Music 情報取得
- `helpers/media_control.sh` - メディア再生コントロール
- `helpers/health_check.sh` - スリープ後のシステム復旧
- AppleScript 実行のリトライロジックとタイムアウト処理を実装
- 権限問題を回避するためにプロセス検出に `pgrep` を使用

### 一般的なコマンド

**設定管理**
```bash
# SketchyBar 設定を再読み込み
sketchybar --reload

# SketchyBar を終了して再起動
sketchybar --exit
sketchybar
```

**開発とテスト**
```bash
# ヘルパープログラムをコンパイル
cd helpers && make

# メディア統合をテスト
./helpers/update_media.sh
./helpers/media_control.sh [previous|playpause|next]

# SketchyBar ログを監視
tail -f /tmp/sketchybar.log
```

**アイテム管理**
```bash
# 特定のアイテムをクエリ
sketchybar --query media

# アイテムを手動で更新
sketchybar --set media label="Test"

# アイテムスクリプトをトリガー
sketchybar --trigger media_update
```

### 開発アーキテクチャ

**モジュラー設計**
- 各アイテムは独自のスタイルとイベント処理を持つ自己完結型
- 設定は集中化されているが、アイテムごとに上書き可能
- ヘルパープログラムは低CPU使用率でのシステム監視を提供
- シェルスクリプトが外部統合（Spotify、システムイベント）を処理

**イベントシステム**
- アイテムは更新に SketchyBar のイベントシステムを使用
- カスタムイベントがスクリプト実行をトリガー
- 設定読み込み時に C ヘルパーの自動コンパイル
- システムスリープからの復旧用ヘルスチェックシステム

**スタイルシステム**
- カスタマイズ可能なテーマを持つ Nord カラースキーム
- 設定による一貫したパディングとスペース
- NerdFont へのフォールバック付き SF Symbols アイコン
- 日本語テキストサポートのための HackGen NF フォント

### ファイル依存関係

システム全体に影響する重要なファイル：
- `sketchybarrc` - 実行可能である必要があり、Lua 環境を設定
- `settings.lua` - すべてのアイテムから参照されるグローバル設定
- `colors.lua` - 全体で使用される色の定義
- `helpers/init.lua` - 起動時に依存関係をコンパイル
- `items/init.lua` - アイテムの読み込み順序を決定

### トラブルシューティング

**設定の問題**
- `sketchybarrc` の権限を確認（実行可能である必要があります）
- ヘルパーコンパイルを確認: `cd helpers && make`
- 必要なすべてのフォントがインストールされていることを確認

**メディア統合の問題**
- Spotify/Apple Music アプリの権限を確認
- スクリプトを直接テスト: `./helpers/update_media.sh`
- プロセスの競合を確認: `pgrep -f "Spotify"`

**パフォーマンスの問題**
- C ヘルパープログラムがシステム監視の CPU 使用量を最小化
- Lua 設定がメモリフットプリントを最小化
- イベント駆動型更新により不要なポーリングを防止