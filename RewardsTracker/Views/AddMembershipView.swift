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
    @State private var programName = ""
    @State private var membershipNumber = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Program Details")) {
                    TextField("Program Name", text: $programName)
                    TextField("Membership Number", text: $membershipNumber)
                }
                
                Section(header: Text("Program Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(ProgramType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
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
                .disabled(programName.isEmpty)
            )
        }
    }
    
    private func saveProgram() {
        let newMembership = MembershipEntity(context: viewContext)
        newMembership.id = UUID()
        newMembership.name = programName
        newMembership.type = selectedType.rawValue
        newMembership.membership_number = membershipNumber
        newMembership.tier = ""  // Default empty tier
        newMembership.tier_progress = 0.0  // Default progress
        
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
