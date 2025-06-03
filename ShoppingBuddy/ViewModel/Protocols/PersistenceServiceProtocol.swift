/// Defines the interface for persistent storage operations of `Item` objects.
///
/// This protocol abstracts the persistence layer, allowing for:
/// - Dependency injection
/// - Easy mocking for testing
/// - Flexible implementation swapping (UserDefaults, CoreData, etc.)
///
/// ## Conformance Requirements:
/// Implementations must provide:
/// 1. A method to save an array of items
/// 2. A method to load previously saved items
///
/// ## Usage Example:
/// ```swift
/// class MyPersistenceService: PersistenceServiceProtocol {
///     func saveItems(_ items: [Item]) {
///         // Implementation here
///     }
///
///     func loadItems() -> [Item] {
///         // Implementation here
///         return []
///     }
/// }
/// ```
protocol PersistenceServiceProtocol {
    /// Saves an array of items to persistent storage
    /// - Parameter items: The array of `Item` objects to be saved
    ///
    /// ## Implementation Notes:
    /// - Should handle serialization internally
    /// - Should overwrite any existing data
    /// - Should not throw (handle errors internally)
    func saveItems(_ items: [Item])
    
    /// Loads previously saved items from persistent storage
    /// - Returns: An array of `Item` objects
    ///
    /// ## Implementation Notes:
    /// - Should return empty array if:
    ///   - No data exists
    ///   - Decoding fails
    /// - Should handle deserialization internally
    /// - Should not throw (handle errors internally)
    func loadItems() -> [Item]
}
