import Foundation
import SwiftUI
import Combine

/// Main view model for managing app-wide data and state
class AppViewModel: ObservableObject {
    /// Published properties for reactive UI updates
    @Published var pets: [Pet] = []
    @Published var bookings: [Booking] = []
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var error: String?
    
    // MARK: - Pet Management
    
    /// Adds a new pet to the system
    func addPet(name: String, breed: String, age: Int, notes: String?, ownerId: String) {
        let newPet = Pet(
            id: UUID().uuidString,
            ownerId: ownerId,
            name: name,
            breed: breed,
            age: age,
            notes: notes
        )
        pets.append(newPet)
    }
    
    /// Retrieves all pets for a specific owner
    func getPetsForOwner(ownerId: String) -> [Pet] {
        return pets.filter { $0.ownerId == ownerId }
    }
    
    // MARK: - Booking Management
    
    /// Creates a new booking in the system
    func createBooking(
        ownerId: String,
        walkerId: String,
        petId: String,
        date: Date,
        duration: Int,
        serviceType: String,
        price: Double,
        notes: String? = nil
    ) {
        let newBooking = Booking(
            id: UUID().uuidString,
            ownerId: ownerId,
            walkerId: walkerId,
            petId: petId,
            date: date,
            duration: duration,
            serviceType: serviceType,
            status: .pending,
            price: price,
            notes: notes,
            isPaid: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        bookings.append(newBooking)
    }
    
    /// Retrieves bookings for a specific user based on their role
    func getBookingsForUser(userId: String, userType: UserType) -> [Booking] {
        switch userType {
        case .owner:
            return bookings.filter { $0.ownerId == userId }
        case .walker:
            return bookings.filter { $0.walkerId == userId }
        case .admin:
            return bookings
        }
    }
    
    /// Updates the status of a booking
    func updateBookingStatus(bookingId: String, newStatus: BookingStatus) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            bookings[index].status = newStatus
            bookings[index].updatedAt = Date()
        }
    }
    
    // MARK: - User Management
    
    /// Retrieves users, optionally filtered by type
    func getUsers(userType: UserType? = nil) -> [User] {
        if let type = userType {
            return users.filter { $0.userType == type }
        }
        return users
    }
    
    /// Updates a user's rating
    func updateUserRating(userId: String, newRating: Int) {
        if let index = users.firstIndex(where: { $0.id == userId }) {
            let user = users[index]
            let currentRating = user.rating ?? 0
            let currentCount = user.numberOfRatings
            
            let newTotalRating = currentRating + Double(newRating)
            let newCount = currentCount + 1
            
            users[index].rating = newTotalRating
            users[index].numberOfRatings = newCount
        }
    }
    
    // MARK: - Helper Methods
    
    /// Formats a number as currency
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    /// Formats a date for display
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 