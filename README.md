# サボトレ MVP (Flutter + Firebase)

ADHD/怠けがちなユーザー向けに、罰金コミットメントでジム通いを習慣化するモバイルアプリのMVPです。

## 実装済みフロー

1. 趣旨説明画面
2. 新規登録画面（名前/性別/メール/電話/パスワード）
3. ログイン画面（メール + Googleボタン）
4. 目標設定（週1〜7回）
5. 罰金説明・同意（チェック必須）
6. 罰金額設定（円）
7. 決済方法リンク誘導（Web支払い起動 + URLコピー）
8. ホーム（大型チェックイン、達成度表示、罰金アラート、サイドメニュー）
9. 進捗詳細（簡易カレンダー・ストリーク・励まし）

## Firebase/Stripe連携ポイント

- `lib/services/firebase_service.dart`
  - Firebase Auth（メール/SMS、Googleログイン）
  - Firebase Storageアップロード
  - Push通知設定
  - 外部Stripe決済URL起動
- `functions/index.js`
  - 週次未達成判定ジョブ（Cloud Scheduler + Functions）
  - Stripe Checkout URL発行Callable Function（雛形）

## 実装メモ

- 位置情報は使わない設計。
- チェックインはアプリ内カメラのみを想定（ギャラリーなし）。
- 目標/罰金はいつでも変更、0円で停止可能。
- アカウント削除導線あり（実処理は要追加）。

## 起動

```bash
flutter pub get
flutter run
```

## FlutterFlow 追加Tips（要求反映）

- 決済誘導ページのボタンに `Launch URL` アクションを設定。
- URLテキストに `Copy to Clipboard` アクションを設定。
- StripeのCheckout SessionはCloud Functions経由で動的生成。
