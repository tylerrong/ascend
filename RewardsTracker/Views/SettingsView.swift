import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("expirationAlertDays") private var expirationAlertDays = 30
    @State private var showingProfileSheet = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(AscendTheme.Colors.primary)
                        VStack(alignment: .leading) {
                            Text(username.isEmpty ? "Set up profile" : username)
                                .font(.headline)
                                .foregroundColor(AscendTheme.Colors.text)
                            Text("Tap to edit profile")
                                .font(.subheadline)
                                .foregroundColor(AscendTheme.Colors.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingProfileSheet = true
                    }
                }
                
                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .foregroundColor(AscendTheme.Colors.text)
                    
                    if notificationsEnabled {
                        Stepper("Alert \(expirationAlertDays) days before expiry", 
                               value: $expirationAlertDays,
                               in: 7...90,
                               step: 7)
                            .foregroundColor(AscendTheme.Colors.text)
                    }
                }
                
                Section("Data Management") {
                    Button("Export Data") {
                        exportData()
                    }
                    .foregroundColor(AscendTheme.Colors.text)
                    
                    Button("Import Data") {
                        importData()
                    }
                    .foregroundColor(AscendTheme.Colors.text)
                }
                
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                        .foregroundColor(AscendTheme.Colors.text)
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                        .foregroundColor(AscendTheme.Colors.text)
                    HStack {
                        Text("Version")
                            .foregroundColor(AscendTheme.Colors.textSecondary)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(AscendTheme.Colors.textSecondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(AscendTheme.Colors.background)
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showingProfileSheet) {
            NavigationView {
                ProfileEditView(username: $username)
                    .navigationTitle("Edit Profile")
            }
        }
    }
    
    private func exportData() {
        // TODO: Implement data export functionality
    }
    
    private func importData() {
        // TODO: Implement data import functionality
    }
}

#Preview {
    SettingsView()
}
