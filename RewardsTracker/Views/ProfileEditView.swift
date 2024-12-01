import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var username: String
    @State private var tempUsername: String = ""
    
    var body: some View {
        Form {
            Section("Profile Information") {
                TextField("Name", text: $tempUsername)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarItems(
            leading: Button("Cancel") { dismiss() },
            trailing: Button("Save") {
                username = tempUsername
                dismiss()
            }
        )
        .onAppear {
            tempUsername = username
        }
    }
}
