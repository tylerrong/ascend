import SwiftUI
import CoreData

struct AddMembershipView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedProgram = ""
    @State private var selectedStatus = ""
    @State private var membershipNumber = ""
    @State private var currentPoints = ""
    
    private var airlinePrograms: [AirlineProgram] {
        AirlineProgramService.shared.getAllPrograms()
    }
    
    private var selectedProgramDetails: AirlineProgram? {
        AirlineProgramService.shared.getProgram(named: selectedProgram)
    }
    
    private var programTiers: [String] {
        selectedProgramDetails?.tiers.map { $0.name } ?? []
    }
    
    private var programWebsite: String {
        selectedProgramDetails?.website ?? "https://www.united.com/mileageplus"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header with back and delete buttons
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .imageScale(.large)
                        }
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .imageScale(.large)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Airline Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Airline")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Picker("Program", selection: $selectedProgram) {
                            Text("Select Program").tag("")
                            ForEach(airlinePrograms, id: \.name) { program in
                                Text(program.name).tag(program.name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8)
                        
                        if !selectedProgram.isEmpty {
                            Link("Visit \(selectedProgram)'s website to know details",
                                 destination: URL(string: programWebsite)!)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !selectedProgram.isEmpty {
                        // Status Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Status")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(programTiers, id: \.self) { tier in
                                        StatusButton(title: tier,
                                                   isSelected: selectedStatus == tier,
                                                   action: { selectedStatus = tier })
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .padding(.horizontal)
                        
                        // Membership Number Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Membership / Frequent Flyer No")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TextField("Enter number", text: $membershipNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.vertical, 8)
                        }
                        .padding(.horizontal)
                        
                        // Current Points Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Points")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            TextField("Enter points", text: $currentPoints)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .padding(.vertical, 8)
                        }
                        .padding(.horizontal)
                        
                        if let program = selectedProgramDetails,
                           let selectedTier = program.tiers.first(where: { $0.name == selectedStatus }) {
                            // Benefits Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Benefits at \(selectedStatus)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                ForEach(selectedTier.benefits, id: \.self) { benefit in
                                    HStack(alignment: .top) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text(benefit)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Requirements Section
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Requirements")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                
                                Text(selectedTier.requirements)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                    
                    // Submit Button
                    Button(action: saveProgram) {
                        Text("Submit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(12)
                    }
                    .padding()
                    .disabled(selectedProgram.isEmpty || membershipNumber.isEmpty || selectedStatus.isEmpty)
                }
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
    }
    
    private func saveProgram() {
        let newMembership = MembershipEntity(context: viewContext)
        newMembership.id = UUID()
        newMembership.name = selectedProgram
        newMembership.type = "airline"
        newMembership.membership_number = membershipNumber
        newMembership.tier = selectedStatus
        newMembership.tier_progress = 0.0
        
        // Set benefits based on selected tier
        if let program = selectedProgramDetails,
           let selectedTier = program.tiers.first(where: { $0.name == selectedStatus }) {
            newMembership.benefits = selectedTier.benefits
        } else {
            newMembership.benefits = ["Basic Member Benefits"]
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving program: \(error.localizedDescription)")
        }
    }
}

struct StatusButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue.opacity(0.8) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}

#Preview {
    AddMembershipView()
        .environment(\.managedObjectContext, PreviewData.preview)
}
