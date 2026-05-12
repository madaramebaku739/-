import SwiftUI

struct MonthlyGoalView: View {
    @EnvironmentObject private var store: RepLockStore
    @Environment(\.dismiss) private var dismiss

    @State private var pushUps = 10
    @State private var squats = 20
    @State private var plank = 1

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 26) {
                    title
                    if let goal = store.state.monthlyGoal, store.hasCurrentMonthGoal {
                        lockedGoal(goal)
                    } else {
                        goalForm
                    }
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MONTHLY GOAL")
                .font(.caption.weight(.bold))
                .tracking(2)
                .foregroundStyle(AppTheme.secondaryText)
            Text("1日の目標回数を決めると、今月中は変更できません。")
                .font(.system(size: 30, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
        }
    }

    private func lockedGoal(_ goal: MonthlyGoal) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("\(goal.title) の目標は固定されています")
                .font(.title3.weight(.semibold))
            ForEach(Exercise.allCases) { exercise in
                HStack {
                    Text(exercise.title)
                    Spacer()
                    Text("\(goal.amount(for: exercise))\(exercise.unit)")
                        .monospacedDigit()
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            Text("次回変更できるのは翌月です。")
                .font(.footnote)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .padding(22)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
    }

    private var goalForm: some View {
        VStack(alignment: .leading, spacing: 22) {
            goalStepper(title: "腕立て伏せ", value: $pushUps, step: 50, unit: "回")
            goalStepper(title: "スクワット", value: $squats, step: 50, unit: "回")
            goalStepper(title: "プランク", value: $plank, step: 1, unit: "回")
            Text("ここで設定するのは1日の目標回数です。未達成分は翌日に負債として追加されます。")
                .font(.footnote)
                .lineSpacing(4)
                .foregroundStyle(AppTheme.secondaryText)
            PrimaryButton(title: "この1日の目標で今月を固定する") {
                store.setMonthlyGoal(pushUps: pushUps, squats: squats, plank: plank)
                dismiss()
            }
        }
        .padding(22)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
    }

    private func goalStepper(title: String, value: Binding<Int>, step: Int, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(value.wrappedValue)\(unit)")
                    .font(.title3.monospacedDigit().weight(.semibold))
            }
            Stepper("", value: value, in: 0...99999, step: step)
                .labelsHidden()
                .tint(.white)
        }
        .foregroundStyle(AppTheme.primaryText)
    }
}
