import Foundation
import CoreData

struct EliteProgressInfo: Codable {
    let current: Int
    let required: Int
    let remaining: Int
    let metric: String
}

extension MembershipEntity {
    var benefits: [String] {
        get {
            if let data = benefits_data,
               let benefits = try? JSONDecoder().decode([String].self, from: data) {
                return benefits
            }
            return []
        }
        set {
            benefits_data = try? JSONEncoder().encode(newValue)
        }
    }
    
    var upcomingBenefits: [String] {
        get {
            if let data = upcomingBenefits_data,
               let benefits = try? JSONDecoder().decode([String].self, from: data) {
                return benefits
            }
            return []
        }
        set {
            upcomingBenefits_data = try? JSONEncoder().encode(newValue)
        }
    }
    
    var statusProgress: EliteProgressInfo? {
        get {
            if let data = statusProgress_data,
               let progress = try? JSONDecoder().decode(EliteProgressInfo.self, from: data) {
                return progress
            }
            return nil
        }
        set {
            statusProgress_data = try? JSONEncoder().encode(newValue)
        }
    }
}
