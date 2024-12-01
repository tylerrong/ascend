import Foundation

class LoyaltyProgramService {
    static let shared = LoyaltyProgramService()
    
    private var programs: [LoyaltyProgram] = []
    
    private init() {
        loadPrograms()
    }
    
    private func loadPrograms() {
        guard let url = Bundle.main.url(forResource: "loyalty_programs", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let programs = try? JSONDecoder().decode([LoyaltyProgram].self, from: data) else {
            print("Error loading loyalty programs")
            return
        }
        self.programs = programs
    }
    
    func getAllPrograms() -> [LoyaltyProgram] {
        return programs
    }
    
    func getPrograms(ofType type: ProgramType) -> [LoyaltyProgram] {
        return programs.filter { $0.type == type }
    }
    
    func searchPrograms(query: String) -> [LoyaltyProgram] {
        guard !query.isEmpty else { return programs }
        return programs.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getProgram(byId id: String) -> LoyaltyProgram? {
        return programs.first { $0.id == id }
    }
}
