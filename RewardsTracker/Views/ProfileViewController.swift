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
                            .foregroundColor(.ascendAccent)
                    }
                    
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("Appearance", systemImage: "paintbrush.fill")
                            .foregroundColor(.ascendAccent)
                    }
                }
                
                Section(header: Text("Data Management")) {
                    Button(action: exportData) {
                        Label("Export Data", systemImage: "square.and.arrow.up")
                            .foregroundColor(.ascendAccent)
                    }
                    
                    Button(action: importData) {
                        Label("Import Data", systemImage: "square.and.arrow.down")
                            .foregroundColor(.ascendAccent)
                    }
                }
                
                Section(header: Text("About")) {
                    Link(destination: URL(string: "https://www.example.com/privacy")!) {
                        Label("Privacy Policy", systemImage: "lock.fill")
                            .foregroundColor(.ascendAccent)
                    }
                    
                    Link(destination: URL(string: "https://www.example.com/terms")!) {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                            .foregroundColor(.ascendAccent)
                    }
                    
                    Label("Version 1.0.0", systemImage: "info.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Profile")
            .background(Color.ascendBackground)
            .accentColor(.ascendAccent)
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
