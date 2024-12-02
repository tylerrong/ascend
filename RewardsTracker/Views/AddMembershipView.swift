import SwiftUI
import CoreData

struct AddMembershipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    enum ProgramType: String, CaseIterable {
        case airline = "airline"
        case hotel = "hotel"
        case membership = "membership"
        
        var displayName: String {
            switch self {
            case .airline: return "Airline"
            case .hotel: return "Hotel"
            case .membership: return "Membership"
            }
        }
    }
    
    @State private var selectedType: ProgramType = .airline
    @State private var selectedProgram: String = ""
    @State private var membershipNumber = ""
    @State private var programName = ""
    
    var availablePrograms: [String] {
        switch selectedType {
        case .airline:
            return ["Delta", "American Airlines", "United"]
        case .hotel:
            return ["Hilton", "Marriott", "Hyatt"]
        case .membership:
            return ["Costco", "Sam's Club", "Amazon Prime"]
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Program Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(ProgramType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section(header: Text("Choose Program")) {
                    Picker("Program", selection: $selectedProgram) {
                        ForEach(availablePrograms, id: \.self) { program in
                            Text(program).tag(program)
                        }
                    }
                }
                
                Section(header: Text("Membership Details")) {
                    TextField("Membership Number", text: $membershipNumber)
                    TextField("Tier", text: $programName)
                }
            }
            .navigationTitle("Add Program")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveProgram()
                }
                .disabled(programName.isEmpty || membershipNumber.isEmpty)
            )
        }
    }
    
    private func saveProgram() {
        let newMembership = MembershipEntity(context: viewContext)
        newMembership.id = UUID()
        newMembership.name = selectedProgram
        newMembership.type = selectedType.rawValue
        newMembership.membership_number = membershipNumber
        newMembership.tier = programName
        newMembership.tier_progress = 0.0
        
        // Set default benefits
        let defaultBenefits = ["Basic Member Benefits"]
        newMembership.benefits = defaultBenefits
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving program: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddMembershipView()
        .environment(\.managedObjectContext, PreviewData.preview)
}
