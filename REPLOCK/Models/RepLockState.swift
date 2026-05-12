import Foundation

struct MonthlyGoal: Codable, Equatable {
    let year: Int
    let month: Int
    var pushUps: Int
    var squats: Int
    var plank: Int
    let lockedAt: Date

    var title: String {
        String(format: "%04d.%02d", year, month)
    }

    func amount(for exercise: Exercise) -> Int {
        switch exercise {
        case .pushUps:
            return pushUps
        case .squats:
            return squats
        case .plank:
            return plank
        }
    }
}

struct DailyLog: Codable, Equatable {
    let dateKey: String
    var pushUps: Int
    var squats: Int
    var plank: Int

    static func empty(dateKey: String) -> DailyLog {
        DailyLog(dateKey: dateKey, pushUps: 0, squats: 0, plank: 0)
    }

    func amount(for exercise: Exercise) -> Int {
        switch exercise {
        case .pushUps:
            return pushUps
        case .squats:
            return squats
        case .plank:
            return plank
        }
    }

    mutating func add(_ value: Int, for exercise: Exercise) {
        switch exercise {
        case .pushUps:
            pushUps += value
        case .squats:
            squats += value
        case .plank:
            plank += value
        }
    }
}

struct ExerciseAmounts: Codable, Equatable {
    var pushUps: Int
    var squats: Int
    var plank: Int

    static let zero = ExerciseAmounts(pushUps: 0, squats: 0, plank: 0)

    func amount(for exercise: Exercise) -> Int {
        switch exercise {
        case .pushUps:
            return pushUps
        case .squats:
            return squats
        case .plank:
            return plank
        }
    }

    mutating func set(_ value: Int, for exercise: Exercise) {
        switch exercise {
        case .pushUps:
            pushUps = max(0, value)
        case .squats:
            squats = max(0, value)
        case .plank:
            plank = max(0, value)
        }
    }
}

struct RepLockState: Codable, Equatable {
    var monthlyGoal: MonthlyGoal?
    var currentDateKey: String
    var todayLog: DailyLog
    var debt: ExerciseAmounts
    var lockedSocialApps: [String]

    static func initial(todayKey: String) -> RepLockState {
        RepLockState(
            monthlyGoal: nil,
            currentDateKey: todayKey,
            todayLog: .empty(dateKey: todayKey),
            debt: .zero,
            lockedSocialApps: ["Instagram", "TikTok", "X", "YouTube"]
        )
    }
}
