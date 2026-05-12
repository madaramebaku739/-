import SwiftUI

struct AchievementView: View {
    @EnvironmentObject private var store: RepLockStore

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(spacing: 28) {
                Spacer()
                Text(store.isUnlocked ? "UNLOCKED" : "LOCKED")
                    .font(.system(size: 48, weight: .semibold))
                    .tracking(1)
                    .foregroundStyle(AppTheme.primaryText)
                Text(store.isUnlocked ? "今日の目標と負債を達成しました。SNS制限解除の条件を満たしています。" : "まだ未達成の種目があります。すべての必要量を完了するとUNLOCKEDになります。")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.horizontal, 12)
                VStack(spacing: 16) {
                    ForEach(Exercise.allCases) { exercise in
                        ExerciseProgressRow(exercise: exercise)
                    }
                }
                .padding(22)
                .background(AppTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                Spacer()
            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
