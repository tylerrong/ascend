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
        memberships.reduce(0) { total, membership in
            total + (membership.value(forKey: "points") as? Int ?? 0)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Portfolio Tab
            NavigationView {
                ScrollView {
                    VStack(spacing: AscendTheme.Spacing.xl) {
                        // Portfolio Header
                        HStack {
                            Text("Portfolio")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: { showingAddMembership.toggle() }) {
                                Text("Add")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AscendTheme.Colors.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(AscendTheme.CornerRadius.sm)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Total Points Card
                        VStack(alignment: .leading, spacing: AscendTheme.Spacing.sm) {
                            Text("Total Points")
                                .font(.subheadline)
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                            Text("\(formatNumber(totalPoints))")
                                .font(.system(size: 36, weight: .bold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(AscendTheme.Colors.surface)
                        .cornerRadius(AscendTheme.CornerRadius.lg)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Points by Type
                        VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                            Text("Points by Type")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack(spacing: AscendTheme.Spacing.md) {
                                PointsTypeCard(title: "Airline Points", points: totalPoints / 2)
                                    .background(AscendTheme.Colors.surface)
                                    .cornerRadius(AscendTheme.CornerRadius.lg)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                                
                                PointsTypeCard(title: "Hotel Points", points: totalPoints / 2)
                                    .background(AscendTheme.Colors.surface)
                                    .cornerRadius(AscendTheme.CornerRadius.lg)
                                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        // Membership Benefits
                        VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                            Text("Membership Benefits")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if memberships.isEmpty {
                                Text("Add your first membership to see benefits")
                                    .font(.subheadline)
                                    .foregroundColor(AscendTheme.Colors.textSecondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                                    .background(AscendTheme.Colors.surface)
                                    .cornerRadius(AscendTheme.CornerRadius.lg)
                            } else {
                                ForEach(memberships) { membership in
                                    BenefitRow(membership: membership)
                                        .padding()
                                        .background(AscendTheme.Colors.surface)
                                        .cornerRadius(AscendTheme.CornerRadius.lg)
                                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(AscendTheme.Colors.background.ignoresSafeArea())
                .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "house")
                    .font(.system(size: 24))
                    .imageScale(.large)
            }
            .tag(0)
            
            // Explore Tab
            ExplorePage()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 24))
                        .imageScale(.large)
                }
                .tag(1)
            
            // Profile Tab
            ProfileViewController()
                .tabItem {
                    Image(systemName: "person")
                        .font(.system(size: 24))
                        .imageScale(.large)
                }
                .tag(2)
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            // Adjust tab bar item appearance
            let itemAppearance = UITabBarItemAppearance()
            
            // Adjust the position of the icons
            itemAppearance.normal.iconColor = UIColor(AscendTheme.Colors.textSecondary)
            itemAppearance.selected.iconColor = UIColor(AscendTheme.Colors.primary)
            
            // Add some padding at the bottom
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // Adjust the height of the tab bar
            UITabBar.appearance().bounds.size.height = 80
        }
        .sheet(isPresented: $showingAddMembership) {
            AddMembershipView()
        }
        .accentColor(AscendTheme.Colors.primary)
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let decimal = Double(number) / 1000.0
            return String(format: "%.1fK", decimal)
        }
        return "\(number)"
    }
}

struct PointsTypeCard: View {
    let title: String
    let points: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(AscendTheme.Colors.textSecondary)
            Text("\(points)")
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AscendTheme.Colors.surface)
        .cornerRadius(AscendTheme.CornerRadius.lg)
    }
}

struct BenefitRow: View {
    let membership: MembershipEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(membership.name ?? "")
                .font(.headline)
            Text(membership.tier ?? "")
                .font(.subheadline)
                .foregroundColor(AscendTheme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AscendTheme.Colors.surface)
        .cornerRadius(AscendTheme.CornerRadius.lg)
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
