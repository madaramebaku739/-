import Foundation

/// Supported exercise categories for the MVP.
enum Exercise: String, CaseIterable, Identifiable, Codable {
    case pushUps
    case squats
    case plank

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pushUps:
            return "腕立て伏せ"
        case .squats:
            return "スクワット"
        case .plank:
            return "プランク"
        }
    }

    var subtitle: String {
        switch self {
        case .pushUps:
            return "下げて上げる動作をVisionでカウント"
        case .squats:
            return "しゃがんで立つ動作をVisionでカウント"
        case .plank:
            return "開始と終了を自分で操作して1回として記録"
        }
    }

    var unit: String { "回" }

    var trackingDescription: String {
        switch self {
        case .pushUps:
            return "体を下げてから上げると1回としてカウントします。横向きで全身が映る位置に置いてください。"
        case .squats:
            return "しゃがんでから立ち上がると1回としてカウントします。全身が映るようにカメラから離れてください。"
        case .plank:
            return "プランクは秒数ではなく回数管理です。開始して姿勢を保ち、終了を押すと1回として記録します。"
        }
    }
}
