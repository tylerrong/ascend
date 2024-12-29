import Foundation
import Combine

// MARK: - Models
public struct AirlineProgram: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let website: String
    public let tiers: [AirlineProgramTier]
    
    public init(id: UUID = UUID(), name: String, website: String, tiers: [AirlineProgramTier]) {
        self.id = id
        self.name = name
        self.website = website
        self.tiers = tiers
    }
}

public struct AirlineProgramTier: Codable, Identifiable {
    public let id: UUID
    public let name: String
    public let requirements: String
    public let benefits: [String]
    
    public init(id: UUID = UUID(), name: String, requirements: String, benefits: [String]) {
        self.id = id
        self.name = name
        self.requirements = requirements
        self.benefits = benefits
    }
}

struct AirlineProgramsResponse: Codable {
    let programs: [AirlineProgram]
}

// MARK: - Service
public final class AirlineProgramService: ObservableObject {
    public static let shared = AirlineProgramService()
    
    @Published private(set) var programs: [AirlineProgram] = []
    
    private init() {
        loadPrograms()
    }
    
    private func loadPrograms() {
        guard let url = Bundle.main.url(forResource: "airline_programs", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Error loading airline programs file")
            return
        }
        
        do {
            let response = try JSONDecoder().decode(AirlineProgramsResponse.self, from: data)
            self.programs = response.programs
        } catch {
            print("Error decoding airline programs: \(error)")
        }
    }
    
    public func getAllPrograms() -> [AirlineProgram] {
        return programs
    }
    
    public func getProgram(named name: String) -> AirlineProgram? {
        return programs.first { $0.name == name }
    }
    
    public func getProgramWebsite(named name: String) -> String? {
        return programs.first { $0.name == name }?.website
    }
    
    public func getProgramTiers(named name: String) -> [AirlineProgramTier]? {
        return programs.first { $0.name == name }?.tiers
    }
}
