import Foundation

/// A service class that handles persistent storage of `Item` objects using UserDefaults.
///
/// Implements `PersistenceServiceProtocol` for dependency injection and testing purposes.
/// Uses JSON encoding/decoding to store and retrieve items.
///
/// ## Usage Example:
/// ```swift
/// let persistence = PersistenceService()
///
/// // Save items
/// persistence.saveItems(itemsArray)
///
/// // Load items
/// let loadedItems = persistence.loadItems()
/// ```
final class PersistenceService: PersistenceServiceProtocol {
    /// The UserDefaults instance used for storage
    private let userDefaults: UserDefaults
    
    /// Initializes the persistence service
    /// - Parameter userDefaults: The UserDefaults instance to use (defaults to .standard)
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    /// Saves an array of items to persistent storage
    /// - Parameter items: The array of `Item` objects to save
    ///
    /// ## Implementation Notes:
    /// - Uses JSON encoding for serialization
    /// - Silently fails if encoding fails (returns without error)
    /// - Overwrites previously saved items
    func saveItems(_ items: [Item]) {
        if let encodedData = try? JSONEncoder().encode(items) {
            userDefaults.set(encodedData, forKey: "savedItems")
        }
    }
    
    /// Loads previously saved items from persistent storage
    /// - Returns: An array of `Item` objects, or empty array if no data exists or decoding fails
    ///
    /// ## Implementation Notes:
    /// - Returns empty array in these cases:
    ///   - No data exists for the key
    ///   - Data exists but decoding fails
    /// - Uses JSON decoding for deserialization
    func loadItems() -> [Item] {
        guard let savedData = userDefaults.data(forKey: "savedItems"),
              let decodedItems = try? JSONDecoder().decode([Item].self, from: savedData) else {
            return []
        }
        return decodedItems
    }
}
