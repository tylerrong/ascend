import SwiftUI

struct MembershipCard: View {
    let membership: MembershipEntity
    
    var body: some View {
        NavigationLink(destination: MembershipDetailView(membership: membership)) {
            HStack(spacing: 16) {
                // Program Logo
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: membership.type == "airline" ? "airplane" : "bed.double")
                        .font(.system(size: 24))
                        .foregroundColor(.ascendAccent)
                }
                
                // Program Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(membership.name ?? "")
                        .font(.headline)
                    Text(membership.membership_number ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text(membership.tier ?? "")
                            .font(.system(size: 12, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.ascendAccent.opacity(0.1))
                            .foregroundColor(.ascendAccent)
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
                
                // Points
                VStack(alignment: .trailing) {
                    Text("90K")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.ascendAccent)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
}
