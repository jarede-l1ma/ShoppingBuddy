import Foundation
import Testing
@testable import ShoppingBuddy

struct PersistenceServiceTests {
    // MARK: - Test Setup
    
    /// Creates a clean instance of PersistenceService with isolated UserDefaults
    /// - Returns: Tuple with the service and UserDefaults instance
    private func makeSUT() -> (PersistenceService, UserDefaults) {
        // Create unique suite name for each test to ensure isolation
        let suiteName = "Test-\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        // Clear any existing data
        userDefaults.removePersistentDomain(forName: suiteName)
        let sut = PersistenceService(userDefaults: userDefaults)
        return (sut, userDefaults)
    }
    
    // MARK: - Test Cases
    
    @Test func saveItems_shouldEncodeAndStoreItems() throws {
        // Given
        let (sut, userDefaults) = makeSUT()
        let testItem = Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages)
        
        // When
        sut.saveItems([testItem])
        
        // Then - Verify data was properly encoded and stored
        let savedData = try #require(userDefaults.data(forKey: "savedItems"))
        let decodedItems = try JSONDecoder().decode([Item].self, from: savedData)
        #expect(decodedItems.count == 1)
        #expect(decodedItems[0].name == testItem.name)
    }
    
    @Test func loadItems_shouldReturnEmptyArrayWhenNoDataSaved() {
        // Given - Freshly created service with clean UserDefaults
        let (sut, _) = makeSUT()
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then
        #expect(loadedItems.isEmpty)
    }
    
    @Test func loadItems_shouldReturnSavedItems() {
        // Given
        let (sut, _) = makeSUT()
        let testItems = [
            Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages),
            Item(name: "Toothpaste", quantity: 1, unitPrice: 2.4, section: .hygiene)
        ]
        sut.saveItems(testItems)
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then - Verify all items were loaded correctly
        #expect(loadedItems.count == testItems.count)
        #expect(loadedItems.contains { $0.name == "Pepsi" })
        #expect(loadedItems.contains { $0.name == "Toothpaste" })
    }
    
    @Test func loadItems_shouldReturnEmptyArrayWhenDataIsCorrupted() {
        // Given
        let (sut, userDefaults) = makeSUT()
        // Store invalid JSON data
        userDefaults.set(Data("invalid data".utf8), forKey: "savedItems")
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then - Should handle corruption gracefully
        #expect(loadedItems.isEmpty)
    }
    
    @Test func saveItems_shouldOverwritePreviousItems() {
        // Given
        let (sut, _) = makeSUT()
        // Initial save
        sut.saveItems([Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages)])
        
        // When - Save new items (should overwrite)
        let newItem = Item(name: "Cola", quantity: 2, unitPrice: 4.5, section: .beverages)
        sut.saveItems([newItem])
        
        // Then - Verify only new items exist
        let loadedItems = sut.loadItems()
        #expect(loadedItems.count == 1)
        #expect(loadedItems[0].name == "Cola")
    }
    
    @Test func integration_saveAndLoadMultipleTimes() {
        // Given
        let (sut, _) = makeSUT()
        
        // First save/load cycle
        let firstItem = Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages)
        sut.saveItems([firstItem])
        #expect(sut.loadItems().count == 1)
        
        // Second save/load cycle (overwrite)
        let secondItems = [
            Item(name: "Cola", quantity: 1, unitPrice: 5.4, section: .beverages),
            Item(name: "Toothpaste", quantity: 1, unitPrice: 2.4, section: .hygiene)
        ]
        sut.saveItems(secondItems)
        #expect(sut.loadItems().count == 2)
        
        // Third save/load cycle (empty)
        sut.saveItems([])
        #expect(sut.loadItems().isEmpty)
    }
}
