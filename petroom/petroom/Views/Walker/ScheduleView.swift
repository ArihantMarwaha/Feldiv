import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                List {
                    Section("Morning") {
                        // TODO: Replace with actual schedule
                        Text("No morning bookings")
                            .foregroundColor(.gray)
                    }
                    
                    Section("Afternoon") {
                        // TODO: Replace with actual schedule
                        Text("No afternoon bookings")
                            .foregroundColor(.gray)
                    }
                    
                    Section("Evening") {
                        // TODO: Replace with actual schedule
                        Text("No evening bookings")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Schedule")
        }
    }
} 