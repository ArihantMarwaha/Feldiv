import SwiftUI

struct OwnerHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingAddPet = false
    @State private var showingBookService = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            QuickActionButton(
                                title: "Book Service",
                                systemImage: "calendar.badge.plus",
                                action: { showingBookService = true }
                            )
                            
                            QuickActionButton(
                                title: "Add Pet",
                                systemImage: "pawprint.circle.fill",
                                action: { showingAddPet = true }
                            )
                            
                            QuickActionButton(
                                title: "View History",
                                systemImage: "clock.fill",
                                action: { /* TODO */ }
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Upcoming Bookings
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming Bookings")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if true { // TODO: Replace with actual bookings check
                            Text("No upcoming bookings")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // TODO: Add booking cards
                        }
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if true { // TODO: Replace with actual activity check
                            Text("No recent activity")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // TODO: Add activity cards
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showingAddPet) {
                // TODO: Add AddPetView
                Text("Add Pet View")
            }
            .sheet(isPresented: $showingBookService) {
                // TODO: Add BookServiceView
                Text("Book Service View")
            }
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImage)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
} 