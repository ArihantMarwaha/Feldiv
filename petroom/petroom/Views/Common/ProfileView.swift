import SwiftUI

/// View for displaying and managing user profile information
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingEditProfile = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Header Section
                Section {
                    HStack {
                        if let profileImageURL = authViewModel.currentUser?.profileImageURL {
                            AsyncImage(url: URL(string: profileImageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(authViewModel.currentUser?.name ?? "")
                                .font(.title2)
                                .bold()
                            Text(authViewModel.currentUser?.email ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Account Information Section
                Section("Account Information") {
                    LabeledContent("Name", value: authViewModel.currentUser?.name ?? "")
                    LabeledContent("Email", value: authViewModel.currentUser?.email ?? "")
                    LabeledContent("Address", value: authViewModel.currentUser?.address ?? "")
                    if let phone = authViewModel.currentUser?.phoneNumber {
                        LabeledContent("Phone", value: phone)
                    }
                }
                
                // Walker Specific Information Section
                if authViewModel.currentUser?.userType == .walker {
                    Section("Walker Information") {
                        if let bio = authViewModel.currentUser?.bio {
                            LabeledContent("Bio", value: bio)
                        }
                        if let rate = authViewModel.currentUser?.hourlyRate {
                            LabeledContent("Hourly Rate", value: String(format: "$%.2f", rate))
                        }
                        if let rating = authViewModel.currentUser?.averageRating {
                            LabeledContent("Rating", value: String(format: "%.1f", rating))
                        }
                    }
                }
                
                // Sign Out Section
                Section {
                    Button(role: .destructive, action: {
                        authViewModel.signOut()
                    }) {
                        Text("Sign Out")
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                Button("Edit") {
                    showingEditProfile = true
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
} 