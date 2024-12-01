import Foundation

struct LoyaltyProgram: Codable, Identifiable {
    let id: String
    let name: String
    let type: ProgramType
    let websiteURL: String
    let logoName: String
    let pointsCurrency: String
    let transferPartners: [String]?
    let estimatedPointValue: Double
    let features: [String]
    let tiers: [ProgramTier]
}

struct ProgramTier: Codable {
    let name: String
    let requirements: String
    let benefits: [String]
}

enum ProgramType: String, Codable {
    case airline
    case hotel
    case premium
}
