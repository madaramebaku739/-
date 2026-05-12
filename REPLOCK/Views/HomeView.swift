import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: RepLockStore

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    header
                    statusCard
                    targetCard
                    actionLinks
                    futureNotice
                }
                .padding(24)
            }
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Dopamine Lock")
                .font(.system(size: 15, weight: .bold))
                .tracking(3)
                .foregroundStyle(AppTheme.secondaryText)
            Text("今日のノルマを終えるまで、SNSを開かない。")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 18)
    }

    private var statusCard: some View {
        MetricCard(
            title: "Status",
            value: store.isUnlocked ? "UNLOCKED" : "LOCKED",
            caption: store.isUnlocked ? "今日の目標と負債を完済しました。" : "今日の目標と過去の負債が残っています。"
        ) {
            HStack(spacing: 12) {
                Circle()
                    .fill(store.isUnlocked ? AppTheme.success : Color.white.opacity(0.35))
                    .frame(width: 10, height: 10)
                Text(store.isUnlocked ? "SNS制限解除の条件を満たしています" : "解除まであと少し")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
    }

    private var targetCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("TODAY")
                        .font(.caption.weight(.semibold))
                        .tracking(1.4)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text("今日の必要量")
                        .font(.title2.weight(.semibold))
                }
                Spacer()
                Text("負債 \(store.totalDebt)")
                    .font(.caption.monospacedDigit())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.10))
                    .clipShape(Capsule())
            }

            ForEach(Exercise.allCases) { exercise in
                ExerciseProgressRow(exercise: exercise)
            }
        }
        .padding(22)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .stroke(AppTheme.hairline, lineWidth: 1)
        )
    }

    private var actionLinks: some View {
        VStack(spacing: 12) {
            NavigationLink {
                MonthlyGoalView()
            } label: {
                rowLabel(title: "今月の1日目標を設定", subtitle: store.canSetMonthlyGoal ? "翌月まで変更できません" : "今月の目標は固定されています")
            }
            NavigationLink {
                ExerciseSelectionView()
            } label: {
                rowLabel(title: "カメラで運動を記録", subtitle: "Visionで端末内姿勢判定")
            }
            NavigationLink {
                AchievementView()
            } label: {
                rowLabel(title: "達成画面", subtitle: "UNLOCKEDの状態を確認")
            }
            NavigationLink {
                SettingsView()
            } label: {
                rowLabel(title: "設定", subtitle: "ロック対象SNSとデータ管理")
            }
        }
    }

    private var futureNotice: some View {
        Text("完全無料・広告なし・課金なしのMVPです。姿勢判定はApple Visionで端末内処理します。将来的にScreen Time API / FamilyControls / ManagedSettings / DeviceActivityでSNS制限を接続します。")
            .font(.footnote)
            .lineSpacing(4)
            .foregroundStyle(AppTheme.secondaryText)
            .padding(.bottom, 24)
    }

    private func rowLabel(title: String, subtitle: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.primaryText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(18)
        .background(AppTheme.elevatedSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
