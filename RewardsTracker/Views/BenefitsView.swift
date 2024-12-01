import SwiftUI

struct BenefitsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MembershipEntity.name, ascending: true)],
        animation: .default)
    private var memberships: FetchedResults<MembershipEntity>
    
    enum BenefitFilter: String, CaseIterable {
        case all = "All"
        case airline = "Airline"
        case hotel = "Hotel"
        case membership = "Membership"
        
        var displayName: String { rawValue }
    }
    
    @State private var selectedFilter = BenefitFilter.all
    @State private var searchText = ""
    
    var filteredMemberships: [MembershipEntity] {
        memberships.filter { membership in
            let matchesFilter = selectedFilter == .all || 
                membership.type?.lowercased() == selectedFilter.rawValue.lowercased()
            let matchesSearch = searchText.isEmpty || 
                membership.name?.localizedCaseInsensitiveContains(searchText) == true
            return matchesFilter && matchesSearch
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchBar(text: $searchText)
                
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(BenefitFilter.allCases, id: \.self) { filter in
                        Text(filter.displayName).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                
                ForEach(filteredMemberships, id: \.id) { membership in
                    BenefitCard(membership: membership)
                }
            }
            .navigationTitle("Benefits")
            .listStyle(PlainListStyle())
        }
    }
}

struct BenefitCard: View {
    let membership: MembershipEntity
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(membership.name ?? "Unknown Program")
                        .font(.headline)
                    Text(membership.tier ?? "No Tier")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    BenefitSection(title: "Current Benefits", benefits: membership.benefits)
                    
                    if !membership.upcomingBenefits.isEmpty {
                        BenefitSection(title: "Next Tier Benefits", benefits: membership.upcomingBenefits)
                    }
                    
                    if let progress = membership.statusProgress {
                        ProgressSection(progress: progress)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct BenefitSection: View {
    let title: String
    let benefits: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ForEach(benefits, id: \.self) { benefit in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(benefit)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct ProgressSection: View {
    let progress: EliteProgressInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Status Progress")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text("\(progress.current) / \(progress.required) \(progress.metric)")
                    .font(.caption)
                Spacer()
                Text("\(progress.remaining) to go")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: Float(progress.current) / Float(progress.required))
                .progressViewStyle(LinearProgressViewStyle())
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search programs", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    BenefitsView()
        .environment(\.managedObjectContext, PreviewData.preview)
}
