import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var store: RepLockStore

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SETTINGS")
                            .font(.caption.weight(.bold))
                            .tracking(2)
                            .foregroundStyle(AppTheme.secondaryText)
                        Text("ロック対象とデータ")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(AppTheme.primaryText)
                    }

                    VStack(alignment: .leading, spacing: 18) {
                        Text("ロック対象SNS（MVP表示）")
                            .font(.headline)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 10)], spacing: 10) {
                            ForEach(store.state.lockedSocialApps, id: \.self) { app in
                                Text(app)
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.white.opacity(0.10))
                                    .clipShape(Capsule())
                            }
                        }
                        Text("実際のアプリ制限は、AppleのScreen Time API / FamilyControls / ManagedSettings / DeviceActivity連携時に追加します。")
                            .font(.footnote)
                            .lineSpacing(4)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .padding(22)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))

                    VStack(alignment: .leading, spacing: 18) {
                        Text("無料版の方針")
                            .font(.headline)
                        Text("現在は完全無料、広告なし、課金なし、プレミアム機能なしです。将来の広告やサブスクリプションは、この設定画面に追加しやすいように分離して扱います。")
                            .font(.footnote)
                            .lineSpacing(4)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                    .padding(22)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))

                    VStack(alignment: .leading, spacing: 18) {
                        Text("端末内保存")
                            .font(.headline)
                        Text("1日の目標、今日の進捗、負債はUserDefaultsに保存されます。カメラ映像や姿勢データをサーバーへ送信しません。")
                            .font(.footnote)
                            .lineSpacing(4)
                            .foregroundStyle(AppTheme.secondaryText)
                        Button(role: .destructive) {
                            store.resetAllData()
                        } label: {
                            Text("すべてのデータをリセット")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.white.opacity(0.10))
                                .foregroundStyle(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                    }
                    .padding(22)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
