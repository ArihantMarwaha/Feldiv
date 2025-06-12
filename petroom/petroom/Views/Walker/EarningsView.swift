import SwiftUI

struct EarningsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedPeriod = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Time Period", selection: $selectedPeriod) {
                    Text("Today").tag(0)
                    Text("This Week").tag(1)
                    Text("This Month").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    Section("Summary") {
                        HStack {
                            Text("Total Earnings")
                            Spacer()
                            Text("$0.00")
                                .bold()
                        }
                        
                        HStack {
                            Text("Completed Jobs")
                            Spacer()
                            Text("0")
                                .bold()
                        }
                        
                        HStack {
                            Text("Average per Job")
                            Spacer()
                            Text("$0.00")
                                .bold()
                        }
                    }
                    
                    Section("Recent Earnings") {
                        // TODO: Replace with actual earnings
                        Text("No recent earnings")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Earnings")
        }
    }
} 