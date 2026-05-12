import SwiftUI

struct ExerciseSelectionView: View {
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                Text("EXERCISE")
                    .font(.caption.weight(.bold))
                    .tracking(2)
                    .foregroundStyle(AppTheme.secondaryText)
                Text("記録する種目を選択")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                VStack(spacing: 14) {
                    ForEach(Exercise.allCases) { exercise in
                        NavigationLink {
                            CountView(exercise: exercise)
                        } label: {
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(exercise.title)
                                        .font(.headline)
                                        .foregroundStyle(AppTheme.primaryText)
                                    Text(exercise.subtitle)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.secondaryText)
                                }
                                Spacer()
                                Image(systemName: "plus")
                                    .foregroundStyle(AppTheme.primaryText)
                            }
                            .padding(22)
                            .background(AppTheme.surface)
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius, style: .continuous))
                        }
                    }
                }
                Spacer()
            }
            .padding(24)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
