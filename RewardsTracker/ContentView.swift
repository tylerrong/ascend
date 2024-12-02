import SwiftUI
import CoreData
import Combine

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
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                HomePage()
            }
            .tabItem {
                Image(systemName: selectedTab == .home ? "airplane.circle.fill" : "airplane.circle")
                Text("Home")
            }
            .tag(Tab.home)
            
            NavigationView {
                ExplorePage()
            }
            .tabItem {
                Image(systemName: selectedTab == .rewards ? "star.circle.fill" : "star.circle")
                Text("Explore")
            }
            .tag(Tab.rewards)
            
            NavigationView {
                BenefitsView()
            }
            .tabItem {
                Image(systemName: selectedTab == .benefits ? "gift.circle.fill" : "gift.circle")
                Text("Benefits")
            }
            .tag(Tab.benefits)
            
            NavigationView {
                ProfileViewController()
            }
            .tabItem {
                Image(systemName: selectedTab == .profile ? "person.circle.fill" : "person.circle")
                Text("Profile")
            }
            .tag(Tab.profile)
        }
        .accentColor(.ascendAccent)
        .background(Color.ascendBackground)
        .background(Color(UIColor.systemGray6))
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = UIColor.systemGray6
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
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
                        Text("Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.ascendAccent)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        SummaryCard(value: "\(totalActiveAccounts)", label: "Active Accounts")
                        SummaryCard(value: "\(totalActiveOffers)", label: "Active Offers")
                        SummaryCard(value: "\(Int(totalProgress * 100))%", label: "Avg Progress")
                        SummaryCard(value: "\(totalBenefits)", label: "Total Benefits")
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
                        MembershipCard(membership: membership)
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
    let value: String
    let label: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.ascendAccent)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.ascendAccent.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct MembershipCard: View {
    let membership: MembershipEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "creditcard.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.ascendAccent)
                
                VStack(alignment: .leading) {
                    Text(membership.name ?? "Unknown Program")
                        .font(.headline)
                    Text(membership.tier ?? "No Tier")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            if let progress = membership.statusProgress {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: Double(progress.current) / Double(progress.required))
                        .tint(.ascendAccent)
                    
                    Text("\(progress.current)/\(progress.required) \(progress.metric)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
