import SwiftUI

struct MembershipDetailView: View {
    let membership: MembershipEntity
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header Section
                VStack(spacing: 15) {
                    // Program Logo and Name
                    VStack {
                        Image(systemName: "creditcard.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .foregroundColor(.accentColor)
                        
                        Text(membership.name ?? "Unknown Program")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    // Membership Number and Tier
                    VStack(spacing: 8) {
                        Text(membership.tier ?? "No Tier")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(membership.membership_number ?? "No Number")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 3)
                
                // Status Progress Section
                if let progress = membership.statusProgress {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Elite Status Progress")
                            .font(.headline)
                        
                        ProgressView(value: Double(progress.current) / Double(progress.required))
                            .tint(.blue)
                        
                        HStack {
                            Text("\(progress.current) / \(progress.required) \(progress.metric)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(progress.remaining) remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
                
                // Current Benefits Section
                if !membership.benefits.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Benefits")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(membership.benefits, id: \.self) { benefit in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text(benefit)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
                
                // Next Tier Benefits Section
                if !membership.upcomingBenefits.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Next Tier Benefits")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(membership.upcomingBenefits, id: \.self) { benefit in
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.orange)
                                Text(benefit)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 3)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditMembershipView(membership: membership)
        }
    }
}

#Preview {
    NavigationView {
        MembershipDetailView(membership: PersistenceController.preview.createSampleMembership())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
