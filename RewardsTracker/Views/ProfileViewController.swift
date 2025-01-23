import SwiftUI

struct ProfileViewController: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userEmail") private var userEmail: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $userName)
                    TextField("Email", text: $userEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section(header: Text("App Settings")) {
                    NavigationLink(destination: NotificationSettingsView()) {
                        Label("Notifications", systemImage: "bell.fill")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                    
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("Appearance", systemImage: "paintbrush.fill")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(action: exportData) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                    
                    Button(action: importData) {
                        Label("Import Data", systemImage: "square.and.arrow.down")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                }
                
                Section(header: Text("About")) {
                    Link(destination: URL(string: "https://www.example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                    
                    Link(destination: URL(string: "https://www.example.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                            .foregroundColor(AscendTheme.Colors.primary)
                    }
                    
                    Label("Version 1.0.0", systemImage: "info.circle.fill")
                        .foregroundColor(AscendTheme.Colors.textSecondary)
                }
            }
            .navigationTitle("Profile")
            .background(AscendTheme.Colors.background.ignoresSafeArea())
            .accentColor(AscendTheme.Colors.primary)
            .scrollContentBackground(.hidden)
        }
    }
    
    private func exportData() {
        // TODO: Implement data export functionality
    }
    
    private func importData() {
        // TODO: Implement data import functionality
    }
}

struct NotificationSettingsView: View {
    @AppStorage("pushNotifications") private var pushNotificationsEnabled = true
    @AppStorage("emailNotifications") private var emailNotificationsEnabled = true
    
    var body: some View {
        Form {
            Section {
                Toggle("Push Notifications", isOn: $pushNotificationsEnabled)
                Toggle("Email Notifications", isOn: $emailNotificationsEnabled)
            }
        }
        .navigationTitle("Notifications")
    }
}

struct AppearanceSettingsView: View {
    @AppStorage("useDarkMode") private var useDarkMode = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Dark Mode", isOn: $useDarkMode)
            }
        }
        .navigationTitle("Appearance")
    }
}

#Preview {
    ProfileViewController()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
