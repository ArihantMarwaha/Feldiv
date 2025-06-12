import SwiftUI

struct WalkerHomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingAvailability = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Summary
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today's Summary")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            SummaryCard(
                                title: "Jobs",
                                value: "0",
                                systemImage: "calendar",
                                color: .blue
                            )
                            
                            SummaryCard(
                                title: "Earnings",
                                value: "$0",
                                systemImage: "dollarsign.circle",
                                color: .green
                            )
                            
                            SummaryCard(
                                title: "Rating",
                                value: "0.0",
                                systemImage: "star.fill",
                                color: .yellow
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Upcoming Jobs
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Upcoming Jobs")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if true { // TODO: Replace with actual jobs check
                            Text("No upcoming jobs")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            // TODO: Add job cards
                        }
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            QuickActionButton(
                                title: "Set Availability",
                                systemImage: "calendar.badge.clock",
                                action: { showingAvailability = true }
                            )
                            
                            QuickActionButton(
                                title: "View Earnings",
                                systemImage: "dollarsign.circle.fill",
                                action: { /* TODO */ }
                            )
                            
                            QuickActionButton(
                                title: "View Reviews",
                                systemImage: "star.fill",
                                action: { /* TODO */ }
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showingAvailability) {
                // TODO: Add AvailabilityView
                Text("Set Availability View")
            }
        }
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 