import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(isDisabled ? Color.white.opacity(0.18) : Color.white)
                .foregroundStyle(isDisabled ? Color.white.opacity(0.42) : Color.black)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .disabled(isDisabled)
    }
}

struct MetricCard<Content: View>: View {
    let title: String
    let value: String
    let caption: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title.uppercased())
                        .font(.caption.weight(.semibold))
                        .tracking(1.4)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text(value)
                        .font(.system(size: 34, weight: .semibold, design: .default))
                        .foregroundStyle(AppTheme.primaryText)
                    Text(caption)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                Spacer()
            }
            content
        }
        .padding(22)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous)
                .stroke(AppTheme.hairline, lineWidth: 1)
        )
    }
}

struct ExerciseProgressRow: View {
    @EnvironmentObject private var store: RepLockStore
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.title)
                        .font(.headline)
                    Text("残り \(store.remaining(for: exercise))\(exercise.unit)")
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                }
                Spacer()
                Text("\(store.progress(for: exercise))/\(store.requiredToday(for: exercise))")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(AppTheme.secondaryText)
            }
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.white.opacity(0.12))
                    Capsule()
                        .fill(Color.white)
                        .frame(width: proxy.size.width * store.progressRatio(for: exercise))
                }
            }
            .frame(height: 7)
        }
        .foregroundStyle(AppTheme.primaryText)
    }
}
