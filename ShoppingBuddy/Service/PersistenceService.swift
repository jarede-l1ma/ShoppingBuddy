import Foundation
/// A service class that handles persistent storage of `Item` objects using FileManager.
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
    /// The URL where items will be saved
    private let fileURL: URL
    
    init(fileName: String = "items.json") {
        self.fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }
    
    /// Saves an array of items to persistent storage
    /// - Parameter items: The array of `Item` objects to save
    ///
    /// ## Implementation Notes:
    /// - Uses JSON encoding for serialization
    /// - Silently fails if encoding fails (returns without error)
    /// - Overwrites previously saved items
    func saveItems(_ items: [Item]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            print("❌ Failed to save items:", error)
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
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("⚠️ Failed to load items:", error)
            return []
        }
    }
}
