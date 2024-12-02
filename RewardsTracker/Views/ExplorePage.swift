import SwiftUI

struct ExplorePage: View {
    @State private var searchText = ""
    @State private var selectedCategoryIndex: Int? = nil
    
    let categories = [
        ("Airlines", "airplane.circle.fill"),
        ("Hotels", "bed.double.circle.fill"),
        ("Credit Cards", "creditcard.circle.fill"),
        ("Premium", "star.circle.fill"),
        ("Dining", "fork.knife.circle.fill"),
        ("Travel", "globe.americas.fill")
    ]
    
    private var exclusivePrograms: [ExclusiveMembership] {
        if searchText.isEmpty {
            return ExclusiveMembershipService.shared.getAllPrograms()
        }
        return ExclusiveMembershipService.shared.searchPrograms(query: searchText)
    }
    
    private var filteredPrograms: [ExclusiveMembership] {
        guard let index = selectedCategoryIndex else {
            return exclusivePrograms
        }
        let category = categories[index].0
        return exclusivePrograms.filter { $0.category == category }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.ascendAccent)
                        TextField("Search programs...", text: $searchText)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Categories")
                            .font(.title2)
                            .foregroundColor(.ascendAccent)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(categories.indices, id: \ .self) { index in
                                    let category = categories[index]
                                    CategoryButton(name: category.0, icon: category.1, isSelected: selectedCategoryIndex == index) {
                                        if selectedCategoryIndex == index {
                                            selectedCategoryIndex = nil
                                        } else {
                                            selectedCategoryIndex = index
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Exclusive Memberships
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Exclusive Memberships")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(filteredPrograms) { program in
                                    ExclusiveProgramCard(program: program)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Featured Deals
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Featured Deals")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(filteredPrograms.prefix(3)) { program in
                                ExclusiveDealCard(program: program)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
            .background(Color.ascendBackground)
            .accentColor(.ascendAccent)
        }
    }
}

struct CategoryButton: View {
    let name: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : .ascendAccent)
                Text(name)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? .white : .ascendAccent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(isSelected ? Color.ascendAccent : Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct ExclusiveProgramCard: View {
    let program: ExclusiveMembership
    
    var body: some View {
        NavigationLink(destination: ExclusiveProgramDetailView(program: program)) {
            VStack(alignment: .leading, spacing: 12) {
                Image(program.logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(program.name)
                        .font(.headline)
                    Text("$\(program.annualFee)/year")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 160)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ExclusiveDealCard: View {
    let program: ExclusiveMembership
    
    var body: some View {
        NavigationLink(destination: ExclusiveProgramDetailView(program: program)) {
            HStack(spacing: 16) {
                Image(program.logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(program.name)
                        .font(.headline)
                    Text(program.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    Text("Join Now")
                        .font(.caption)
                        .foregroundColor(.ascendAccent)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ExclusiveProgramDetailView: View {
    let program: ExclusiveMembership
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 16) {
                    Image(program.logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                    
                    Text(program.name)
                        .font(.title)
                        .bold()
                    
                    Text(program.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("$\(program.annualFee)/year")
                        .font(.headline)
                        .foregroundColor(.ascendAccent)
                }
                
                // Benefits
                VStack(alignment: .leading, spacing: 12) {
                    Text("Benefits")
                        .font(.title2)
                        .bold()
                    
                    ForEach(program.benefits, id: \.self) { benefit in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(benefit)
                        }
                    }
                }
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features")
                        .font(.title2)
                        .bold()
                    
                    ForEach(program.features, id: \.self) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.yellow)
                            Text(feature)
                        }
                    }
                }
                
                // Apply Button
                Link(destination: URL(string: program.websiteURL)!) {
                    Text("Apply Now")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.ascendAccent)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ExplorePage()
}
