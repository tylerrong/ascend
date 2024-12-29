import SwiftUI
import CoreData

extension Color {
    static let ascendBackground = Color(hex: "F1EEE9")
    static let ascendAccent = Color(hex: "2C3E50")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum Tab {
    case home, rewards, benefits, profile
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MembershipEntity.name, ascending: true)],
        animation: .default)
    private var memberships: FetchedResults<MembershipEntity>
    
    @State private var showingAddMembership = false
    @State private var selectedTab = 0
    
    var totalPoints: Int {
        // Calculate total points from all memberships
        // This is a placeholder - implement actual calculation
        91200
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                ScrollView {
                    VStack(spacing: 24) {
                        // Points Summary Card
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.ascendAccent)
                                .frame(height: 200)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(formatNumber(totalPoints))")
                                    .font(.system(size: 48, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Total Points")
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                        }
                        .padding(.horizontal)
                        
                        // Memberships Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Your Memberships")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Button("+ ADD MORE") {
                                    showingAddMembership = true
                                }
                                .foregroundColor(.ascendAccent)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            
                            ForEach(memberships) { membership in
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
                                .padding(.horizontal)
                            }
                        }
                        
                        // Recent Articles Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recent Articles")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                NavigationLink("See All") {
                                    Text("Articles View") // Placeholder
                                }
                                .foregroundColor(.ascendAccent)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(1...3, id: \.self) { _ in
                                        ArticleCard()
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.ascendAccent)
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)
            
            // Explore Tab
            ExplorePage()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "airplane.circle.fill" : "airplane.circle")
                    Text("Explore")
                }
                .tag(1)
            
            // Profile Tab
            ProfileViewController()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "person.fill" : "person")
                    Text("Profile")
                }
                .tag(2)
        }
        .sheet(isPresented: $showingAddMembership) {
            AddMembershipView()
        }
        .accentColor(.ascendAccent)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let decimal = Double(number) / 1000.0
            return String(format: "%.1fK", decimal)
        }
        return "\(number)"
    }
}

struct ArticleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image("article-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()
                .cornerRadius(16)
            
            Text("Earn Avios with Accor: Double Rewards")
                .font(.headline)
                .lineLimit(2)
                .padding(.horizontal)
            
            Text("Learn how to maximize your earnings with our latest partnership")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .frame(width: 300)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}

struct HomePage: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MembershipEntity.name, ascending: true)],
        animation: .default)
    private var memberships: FetchedResults<MembershipEntity>
    
    @State private var showingAddMembership = false
    @State private var showingOverview = false
    
    private var totalActiveAccounts: Int {
        memberships.count
    }
    
    private var totalActiveOffers: Int {
        memberships.reduce(0) { count, membership in
            count + membership.upcomingBenefits.count
        }
    }
    
    private var totalProgress: Double {
        let progress = memberships.reduce(0.0) { sum, membership in
            sum + membership.tier_progress
        }
        return progress / Double(max(memberships.count, 1))
    }
    
    private var totalBenefits: Int {
        memberships.reduce(0) { count, membership in
            count + membership.benefits.count
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Your Portfolio")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.ascendAccent)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        SummaryCard(
                            icon: "creditcard.circle.fill",
                            value: "\(totalActiveAccounts)",
                            label: "Active\nAccounts"
                        )
                        SummaryCard(
                            icon: "gift.circle.fill",
                            value: "\(totalActiveOffers)",
                            label: "Active\nOffers"
                        )
                        SummaryCard(
                            icon: "chart.line.uptrend.xyaxis.circle.fill",
                            value: "\(Int(totalProgress * 100))%",
                            label: "Average\nProgress"
                        )
                        SummaryCard(
                            icon: "star.circle.fill",
                            value: "\(totalBenefits)",
                            label: "Total\nBenefits"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
                
                Text("Your Memberships")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.ascendAccent)
                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(memberships) { membership in
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
                                Text(membership.tier ?? "No Tier")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
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
            .padding(.vertical)
        }
        .background(Color.ascendBackground)
        .accentColor(.ascendAccent)
        .navigationBarItems(trailing: Button(action: {
            showingAddMembership = true
        }) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.ascendAccent)
        })
        .sheet(isPresented: $showingAddMembership) {
            AddMembershipView()
        }
    }
}

struct SummaryCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.ascendAccent)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.ascendAccent)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.ascendAccent.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
