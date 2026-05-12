import Combine
import Foundation

@MainActor
final class RepLockStore: ObservableObject {
    @Published private(set) var state: RepLockState

    private let storageKey = "replock.state.v1"
    private let calendar = Calendar.current
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        let todayKey = Self.dateKey(for: Date())
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let saved = try? decoder.decode(RepLockState.self, from: data) {
            state = saved
        } else {
            state = .initial(todayKey: todayKey)
        }
        rollOverIfNeeded(to: Date())
    }

    var hasCurrentMonthGoal: Bool {
        guard let goal = state.monthlyGoal else { return false }
        let components = calendar.dateComponents([.year, .month], from: Date())
        return goal.year == components.year && goal.month == components.month
    }

    var canSetMonthlyGoal: Bool {
        !hasCurrentMonthGoal
    }

    var isUnlocked: Bool {
        Exercise.allCases.allSatisfy { progress(for: $0) >= requiredToday(for: $0) }
    }

    var totalDebt: Int {
        Exercise.allCases.reduce(0) { $0 + state.debt.amount(for: $1) }
    }

    func setMonthlyGoal(pushUps: Int, squats: Int, plank: Int) {
        guard canSetMonthlyGoal else { return }
        let components = calendar.dateComponents([.year, .month], from: Date())
        guard let year = components.year, let month = components.month else { return }
        state.monthlyGoal = MonthlyGoal(
            year: year,
            month: month,
            pushUps: max(0, pushUps),
            squats: max(0, squats),
            plank: max(0, plank),
            lockedAt: Date()
        )
        save()
    }

    func addProgress(_ amount: Int, for exercise: Exercise) {
        rollOverIfNeeded(to: Date())
        state.todayLog.add(max(0, amount), for: exercise)
        save()
    }

    func progress(for exercise: Exercise) -> Int {
        state.todayLog.amount(for: exercise)
    }

    func dailyBaseTarget(for exercise: Exercise) -> Int {
        guard let goal = state.monthlyGoal else { return 0 }
        return goal.amount(for: exercise)
    }

    func requiredToday(for exercise: Exercise) -> Int {
        dailyBaseTarget(for: exercise) + state.debt.amount(for: exercise)
    }

    func remaining(for exercise: Exercise) -> Int {
        max(0, requiredToday(for: exercise) - progress(for: exercise))
    }

    func progressRatio(for exercise: Exercise) -> Double {
        let required = requiredToday(for: exercise)
        guard required > 0 else { return 1 }
        return min(1, Double(progress(for: exercise)) / Double(required))
    }

    func resetAllData() {
        state = .initial(todayKey: Self.dateKey(for: Date()))
        save()
    }

    private func rollOverIfNeeded(to date: Date) {
        let newKey = Self.dateKey(for: date)
        guard state.currentDateKey != newKey else { return }

        var nextDebt = ExerciseAmounts.zero
        for exercise in Exercise.allCases {
            let unpaid = max(0, requiredToday(for: exercise) - state.todayLog.amount(for: exercise))
            nextDebt.set(unpaid, for: exercise)
        }

        state.currentDateKey = newKey
        state.todayLog = .empty(dateKey: newKey)
        state.debt = nextDebt
        save()
    }

    private func save() {
        guard let data = try? encoder.encode(state) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
