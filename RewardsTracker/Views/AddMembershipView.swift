import SwiftUI

struct AddMembershipView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selectedType: MembershipType?
    @State private var name: String = ""
    @State private var membershipNumber: String = ""
    @State private var tier: String = ""
    @State private var currentPoints: String = ""
    
    enum MembershipType: String, CaseIterable {
        case airline = "Airline"
        case hotel = "Hotel"
        case other = "Membership"
    }
    
    var body: some View {
        NavigationView {
            if selectedType == nil {
                // Selection View
                VStack(spacing: AscendTheme.Spacing.lg) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(AscendTheme.Colors.text)
                        }
                        Text("Select")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(AscendTheme.Colors.text)
                        Spacer()
                    }
                    .padding(.bottom, AscendTheme.Spacing.md)
                    
                    // Membership Type Selection
                    VStack(spacing: AscendTheme.Spacing.md) {
                        ForEach(MembershipType.allCases, id: \.self) { type in
                            Button(action: { selectedType = type }) {
                                HStack {
                                    Text(type.rawValue)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(AscendTheme.Colors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(AscendTheme.CornerRadius.md)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom Navigation Bar
                    HStack(spacing: AscendTheme.Spacing.xl) {
                        Button(action: {}) {
                            Image(systemName: "house")
                                .font(.system(size: 20))
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "person")
                                .font(.system(size: 20))
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                        }
                    }
                    .padding(.top, AscendTheme.Spacing.md)
                    .padding(.bottom, AscendTheme.Spacing.sm)
                }
                .padding()
                .background(AscendTheme.Colors.background.ignoresSafeArea())
            } else {
                // Add Membership Form
                ScrollView {
                    VStack(spacing: AscendTheme.Spacing.xl) {
                        VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                            Text(selectedType?.rawValue ?? "")
                                .font(.headline)
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                            
                            TextField("Name", text: $name)
                                .textFieldStyle(AscendTextFieldStyle())
                            
                            TextField("Membership ID", text: $membershipNumber)
                                .textFieldStyle(AscendTextFieldStyle())
                            
                            TextField("Current Points", text: $currentPoints)
                                .textFieldStyle(AscendTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("Tier", text: $tier)
                                .textFieldStyle(AscendTextFieldStyle())
                        }
                        
                        Button("Add") {
                            addMembership()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AscendTheme.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(AscendTheme.CornerRadius.md)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarItems(
                    leading: Button("Back") {
                        selectedType = nil
                    }
                )
            }
        }
    }
    
    private func addMembership() {
        let membership = MembershipEntity(context: viewContext)
        membership.id = UUID()
        membership.name = name
        membership.membership_number = membershipNumber
        membership.tier = tier
        membership.type = selectedType?.rawValue.lowercased() ?? "other"
        
        if let points = Int64(currentPoints) {
            membership.points = points
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving membership: \(error)")
        }
    }
}

#Preview {
    AddMembershipView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
