import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("expirationAlertDays") private var expirationAlertDays = 30
    @State private var showingProfileSheet = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Profile") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(username.isEmpty ? "Set up profile" : username)
                                .font(.headline)
                            Text("Tap to edit profile")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                    
                    if notificationsEnabled {
                        Stepper("Alert \(expirationAlertDays) days before expiry", 
                               value: $expirationAlertDays,
                               in: 7...90,
                               step: 7)
                    }
                }
                
                Section("Data Management") {
                    Button("Export Data") {
                        exportData()
                    }
                    
                    Button("Import Data") {
                        importData()
                    }
                }
                
                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
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
