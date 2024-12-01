import Foundation

enum MembershipType {
    case airline
    case hotel
    case premium
}

enum ConnectionMethod {
    case manual
    case automatic
}

struct Perk: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let isActive: Bool
}

struct Membership: Identifiable {
    let id = UUID()
    let name: String
    let type: MembershipType
    let tier: String
    let membershipID: String?
    let connectionMethod: ConnectionMethod
    let perks: [Perk]
    let logoName: String
    
    // Additional metadata
    let expirationDate: Date?
    let pointsBalance: Int?
}

class MembershipStore: ObservableObject {
    @Published var memberships: [Membership] = []
    
    func addMembership(_ membership: Membership) {
        memberships.append(membership)
    }
    
    func removeMembership(at index: Int) {
        memberships.remove(at: index)
    }
    
    func connectAutomatically(membershipID: String) {
        // TODO: Implement API connection logic
    }
}
