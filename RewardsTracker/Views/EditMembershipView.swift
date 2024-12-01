import SwiftUI
import CoreData

struct EditMembershipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    let membership: MembershipEntity
    
    @State private var programName: String
    @State private var membershipNumber: String
    @State private var tier: String
    @State private var tierProgress: Double
    @State private var benefits: [String]
    @State private var upcomingBenefits: [String]
    
    init(membership: MembershipEntity) {
        self.membership = membership
        _programName = State(initialValue: membership.name ?? "")
        _membershipNumber = State(initialValue: membership.membership_number ?? "")
        _tier = State(initialValue: membership.tier ?? "")
        _tierProgress = State(initialValue: membership.tier_progress)
        _benefits = State(initialValue: membership.benefits)
        _upcomingBenefits = State(initialValue: membership.upcomingBenefits)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Program Details")) {
                    TextField("Program Name", text: $programName)
                    TextField("Membership Number", text: $membershipNumber)
                    TextField("Current Tier", text: $tier)
                    
                    HStack {
                        Text("Tier Progress")
                        Slider(value: $tierProgress, in: 0...1, step: 0.01)
                        Text("\(Int(tierProgress * 100))%")
                    }
                }
                
                Section(header: Text("Current Benefits")) {
                    ForEach(benefits.indices, id: \.self) { index in
                        TextField("Benefit", text: $benefits[index])
                    }
                    .onDelete { indexSet in
                        benefits.remove(atOffsets: indexSet)
                    }
                    
                    Button("Add Benefit") {
                        benefits.append("New Benefit")
                    }
                }
                
                Section(header: Text("Next Tier Benefits")) {
                    ForEach(upcomingBenefits.indices, id: \.self) { index in
                        TextField("Benefit", text: $upcomingBenefits[index])
                    }
                    .onDelete { indexSet in
                        upcomingBenefits.remove(atOffsets: indexSet)
                    }
                    
                    Button("Add Upcoming Benefit") {
                        upcomingBenefits.append("New Benefit")
                    }
                }
            }
            .navigationTitle("Edit Program")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
            )
        }
    }
    
    private func saveChanges() {
        membership.name = programName
        membership.membership_number = membershipNumber
        membership.tier = tier
        membership.tier_progress = tierProgress
        membership.benefits = benefits
        membership.upcomingBenefits = upcomingBenefits
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditMembershipView(membership: PreviewData.preview.registeredObjects.first(where: { $0 is MembershipEntity }) as! MembershipEntity)
        .environment(\.managedObjectContext, PreviewData.preview)
}
