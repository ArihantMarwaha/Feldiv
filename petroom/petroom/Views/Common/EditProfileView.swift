import SwiftUI
import PhotosUI

/// View for editing user profile information
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Form fields
    @State private var name: String
    @State private var email: String
    @State private var phoneNumber: String
    @State private var address: String
    @State private var bio: String
    @State private var hourlyRate: String
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var imageData: Data?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    init() {
        let user = AuthViewModel.shared.currentUser
        _name = State(initialValue: user?.name ?? "")
        _email = State(initialValue: user?.email ?? "")
        _phoneNumber = State(initialValue: user?.phoneNumber ?? "")
        _address = State(initialValue: user?.address ?? "")
        _bio = State(initialValue: user?.bio ?? "")
        _hourlyRate = State(initialValue: user?.hourlyRate.map { String(format: "%.2f", $0) } ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Profile Image Section
                Section {
                    HStack {
                        Spacer()
                        VStack {
                            if let profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else if let imageURL = authViewModel.currentUser?.profileImageURL {
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }
                            
                            PhotosPicker(selection: $selectedImage,
                                       matching: .images) {
                                Text("Change Photo")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical)
                }
                
                // Basic Information Section
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Phone Number", text: $phoneNumber)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                    TextField("Address", text: $address)
                        .textContentType(.fullStreetAddress)
                }
                
                // Walker Specific Information
                if authViewModel.currentUser?.userType == .walker {
                    Section("Walker Information") {
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                        
                        TextField("Hourly Rate", text: $hourlyRate)
                            .keyboardType(.decimalPad)
                    }
                }
                
                // Error Message
                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await saveProfile()
                        }
                    }
                    .disabled(isLoading)
                }
            }
            .onChange(of: selectedImage) { newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        imageData = data
                        profileImage = Image(uiImage: uiImage)
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
    
    /// Saves the updated profile information
    private func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        // Validate input
        guard !name.isEmpty else {
            errorMessage = "Name cannot be empty"
            isLoading = false
            return
        }
        
        guard !email.isEmpty else {
            errorMessage = "Email cannot be empty"
            isLoading = false
            return
        }
        
        do {
            // Create updated user
            var updatedUser = authViewModel.currentUser
            updatedUser?.name = name
            updatedUser?.email = email
            updatedUser?.phoneNumber = phoneNumber
            updatedUser?.address = address
            
            if authViewModel.currentUser?.userType == .walker {
                updatedUser?.bio = bio
                if let rate = Double(hourlyRate) {
                    updatedUser?.hourlyRate = rate
                }
            }
            
            // Upload profile image if changed
            if let imageData = imageData {
                let imageURL = try await authViewModel.uploadProfileImage(imageData)
                updatedUser?.profileImageURL = imageURL
            }
            
            // Update user profile
            try await authViewModel.updateProfile(updatedUser)
            await MainActor.run {
                dismiss()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

#Preview {
    EditProfileView()
        .environmentObject(AuthViewModel())
} 