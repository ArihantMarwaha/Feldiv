import SwiftUI

struct BookingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Booking Status", selection: $selectedTab) {
                    Text("Upcoming").tag(0)
                    Text("Past").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == 0 {
                    UpcomingBookingsView()
                } else {
                    PastBookingsView()
                }
            }
            .navigationTitle("Bookings")
        }
    }
}

struct UpcomingBookingsView: View {
    var body: some View {
        List {
            // TODO: Replace with actual bookings
            Text("No upcoming bookings")
                .foregroundColor(.gray)
        }
    }
}

struct PastBookingsView: View {
    var body: some View {
        List {
            // TODO: Replace with actual bookings
            Text("No past bookings")
                .foregroundColor(.gray)
        }
    }
} 