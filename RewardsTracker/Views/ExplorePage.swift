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
                VStack(spacing: AscendTheme.Spacing.xl) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AscendTheme.Colors.primary)
                        TextField("Search programs...", text: $searchText)
                    }
                    .padding()
                    .background(AscendTheme.Colors.surface)
                    .cornerRadius(AscendTheme.CornerRadius.lg)
                    .padding(.horizontal)
                    
                    // Categories
                    VStack(alignment: .leading, spacing: AscendTheme.Spacing.lg) {
                        Text("Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AscendTheme.Colors.textPrimary)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AscendTheme.Spacing.md) {
                                ForEach(categories.indices, id: \.self) { index in
                                    let category = categories[index]
                                    CategoryButton(name: category.0, icon: category.1, isSelected: selectedCategoryIndex == index) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            if selectedCategoryIndex == index {
                                                selectedCategoryIndex = nil
                                            } else {
                                                selectedCategoryIndex = index
                                            }
                                        }
                                    }
                                    .frame(width: 100)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, AscendTheme.Spacing.md)
                    
                    // Exclusive Memberships
                    VStack(alignment: .leading, spacing: AscendTheme.Spacing.lg) {
                        Text("Exclusive Memberships")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AscendTheme.Spacing.md) {
                                ForEach(filteredPrograms) { program in
                                    ExclusiveProgramCard(program: program)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Featured Deals
                    VStack(alignment: .leading, spacing: AscendTheme.Spacing.lg) {
                        Text("Featured Deals")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        VStack(spacing: AscendTheme.Spacing.md) {
                            ForEach(filteredPrograms.prefix(3)) { program in
                                ExclusiveDealCard(program: program)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(AscendTheme.Colors.background.ignoresSafeArea())
            .navigationTitle("Explore")
            .accentColor(AscendTheme.Colors.primary)
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
            VStack(spacing: AscendTheme.Spacing.md) {
                ZStack {
                    Circle()
                        .fill(isSelected ? AscendTheme.Colors.primary : AscendTheme.Colors.surface)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(isSelected ? .white : AscendTheme.Colors.primary)
                }
                
                Text(name)
                    .font(.system(size: 12, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? AscendTheme.Colors.primary : AscendTheme.Colors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, AscendTheme.Spacing.md)
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct ExclusiveProgramCard: View {
    let program: ExclusiveMembership
    
    var body: some View {
        NavigationLink(destination: ExclusiveProgramDetailView(program: program)) {
            VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                Image(program.logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 60)
                    .cornerRadius(AscendTheme.CornerRadius.sm)
                
                VStack(alignment: .leading, spacing: AscendTheme.Spacing.xs) {
                    Text(program.name)
                        .font(.headline)
                    Text("$\(program.annualFee)/year")
                        .font(.subheadline)
                        .foregroundColor(AscendTheme.Colors.textSecondary)
                }
            }
            .frame(width: 160)
            .padding()
            .background(AscendTheme.Colors.surface)
            .cornerRadius(AscendTheme.CornerRadius.lg)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct ExclusiveDealCard: View {
    let program: ExclusiveMembership
    
    var body: some View {
        NavigationLink(destination: ExclusiveProgramDetailView(program: program)) {
            HStack(spacing: AscendTheme.Spacing.md) {
                Image(program.logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .cornerRadius(AscendTheme.CornerRadius.sm)
                
                VStack(alignment: .leading, spacing: AscendTheme.Spacing.xs) {
                    Text(program.name)
                        .font(.headline)
                    Text(program.description)
                        .font(.subheadline)
                        .foregroundColor(AscendTheme.Colors.textSecondary)
                        .lineLimit(2)
                    Text("Join Now")
                        .font(.caption)
                        .foregroundColor(AscendTheme.Colors.primary)
                        .padding(.top, AscendTheme.Spacing.xs)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(AscendTheme.Colors.textSecondary)
            }
            .padding()
            .background(AscendTheme.Colors.surface)
            .cornerRadius(AscendTheme.CornerRadius.lg)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ExclusiveProgramDetailView: View {
    let program: ExclusiveMembership
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AscendTheme.Spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: AscendTheme.Spacing.lg) {
                    Image(program.logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 80)
                    
                    Text(program.name)
                        .font(.title)
                        .bold()
                    
                    Text(program.description)
                        .font(.body)
                        .foregroundColor(AscendTheme.Colors.textSecondary)
                    
                    Text("$\(program.annualFee)/year")
                        .font(.headline)
                        .foregroundColor(AscendTheme.Colors.primary)
                }
                
                // Benefits
                VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                    Text("Benefits")
                        .font(.title2)
                        .bold()
                    
                    ForEach(program.benefits, id: \.self) { benefit in
                        HStack(spacing: AscendTheme.Spacing.md) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(benefit)
                        }
                    }
                }
                
                // Features
                VStack(alignment: .leading, spacing: AscendTheme.Spacing.md) {
                    Text("Features")
                        .font(.title2)
                        .bold()
                    
                    ForEach(program.features, id: \.self) { feature in
                        HStack(spacing: AscendTheme.Spacing.md) {
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
                        .background(AscendTheme.Colors.primary)
                        .cornerRadius(AscendTheme.CornerRadius.lg)
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
