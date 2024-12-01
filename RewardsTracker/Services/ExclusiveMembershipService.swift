import Foundation

struct ExclusiveMembership: Codable, Identifiable {
    let id: String
    let name: String
    let type: String
    let websiteURL: String
    let logoName: String
    let annualFee: Int
    let features: [String]
    let benefits: [String]
    let description: String
}

class ExclusiveMembershipService {
    static let shared = ExclusiveMembershipService()
    
    private var programs: [ExclusiveMembership] = []
    
    private init() {
        loadPrograms()
    }
    
    private func loadPrograms() {
        guard let url = Bundle.main.url(forResource: "exclusive_memberships", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(ExclusiveProgramsResponse.self, from: data) else {
            print("Error loading exclusive programs")
            return
        }
        self.programs = response.programs
    }
    
    func getAllPrograms() -> [ExclusiveMembership] {
        return programs
    }
    
    func searchPrograms(query: String) -> [ExclusiveMembership] {
        guard !query.isEmpty else { return programs }
        return programs.filter {
            $0.name.localizedCaseInsensitiveContains(query) ||
            $0.description.localizedCaseInsensitiveContains(query)
        }
    }
}

private struct ExclusiveProgramsResponse: Codable {
    let programs: [ExclusiveMembership]
}
