import Foundation

struct ExclusiveMembership: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let type: String
    let category: String
    let logoName: String
    let websiteURL: String
    let annualFee: Int
    let tiers: [String]
    let features: [String]
    let benefits: [String]
    let upcomingBenefits: [String]
    let requirements: String
    let imageURL: String
}

class ExclusiveMembershipService: ObservableObject {
    static let shared = ExclusiveMembershipService()
    
    @Published private var programs: [ExclusiveMembership] = []
    
    private init() {
        loadPrograms()
    }
    
    private func loadPrograms() {
        if let url = Bundle.main.url(forResource: "exclusive_programs", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(ProgramsResponse.self, from: data) {
            self.programs = decoded.programs
        } else {
            // Load default programs if JSON fails
            programs = [
                ExclusiveMembership(
                    id: UUID(),
                    name: "American Express Platinum",
                    description: "Premium travel rewards card with extensive benefits",
                    type: "Credit Card",
                    category: "Credit Cards",
                    logoName: "amex-logo",
                    websiteURL: "https://www.americanexpress.com/platinum",
                    annualFee: 695,
                    tiers: ["Platinum", "Business Platinum"],
                    features: ["Airport Lounge Access", "Hotel Elite Status"],
                    benefits: ["$200 Airline Fee Credit", "Uber Credits", "Global Entry Credit"],
                    upcomingBenefits: ["New Digital Entertainment Credit"],
                    requirements: "Excellent Credit Score Required",
                    imageURL: "amex-platinum"
                ),
                ExclusiveMembership(
                    id: UUID(),
                    name: "United MileagePlus",
                    description: "Premier airline loyalty program",
                    type: "Airline",
                    category: "Airlines",
                    logoName: "united-logo",
                    websiteURL: "https://www.united.com/mileageplus",
                    annualFee: 0,
                    tiers: ["Premier Silver", "Premier Gold", "Premier Platinum", "Premier 1K"],
                    features: ["Priority Check-in", "Lounge Access"],
                    benefits: ["Free Checked Bags", "Priority Boarding", "Seat Upgrades"],
                    upcomingBenefits: ["New International Lounge Access"],
                    requirements: "Flight Status Requirements",
                    imageURL: "united-mileageplus"
                )
            ]
        }
    }
    
    func getAllPrograms() -> [ExclusiveMembership] {
        return programs
    }
    
    func searchPrograms(query: String) -> [ExclusiveMembership] {
        if query.isEmpty { return programs }
        return programs.filter { program in
            program.name.localizedCaseInsensitiveContains(query) ||
            program.description.localizedCaseInsensitiveContains(query)
        }
    }
}

private struct ProgramsResponse: Codable {
    let programs: [ExclusiveMembership]
}
