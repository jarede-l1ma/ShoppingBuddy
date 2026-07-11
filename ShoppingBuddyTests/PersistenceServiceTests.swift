import Foundation
import Testing
@testable import ShoppingBuddy

struct PersistenceServiceTests {
    // MARK: - Test Setup
    
    private func makeSUT() -> (PersistenceService, String) {
        let fileName = "test_items_\(UUID().uuidString).json"
        let sut = PersistenceService(fileName: fileName)
        return (sut, fileName)
    }
    
    private func cleanUp(fileName: String) {
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    // MARK: - Test Cases
    
    @Test func saveItems_shouldEncodeAndStoreItems() async throws {
        // Given
        let (sut, fileName) = makeSUT()
        let testItem = Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages)
        
        // When
        sut.saveItems([testItem])
        
        // Espera o debounce e o save (0.5s + margem)
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        
        let savedData = try #require(try Data(contentsOf: fileURL))
        let decodedItems = try JSONDecoder().decode([Item].self, from: savedData)
        #expect(decodedItems.count == 1)
        #expect(decodedItems[0].name == testItem.name)
        
        cleanUp(fileName: fileName)
    }
    
    @Test func loadItems_shouldReturnEmptyArrayWhenNoDataSaved() {
        // Given
        let (sut, fileName) = makeSUT()
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then
        #expect(loadedItems.isEmpty)
        
        cleanUp(fileName: fileName)
    }
    
    @Test func loadItems_shouldReturnSavedItems() async throws {
        // Given
        let (sut, fileName) = makeSUT()
        let testItems = [
            Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages),
            Item(name: "Toothpaste", quantity: 1, unitPrice: 2.4, section: .hygiene)
        ]
        sut.saveItems(testItems)
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then
        #expect(loadedItems.count == testItems.count)
        #expect(loadedItems.contains { $0.name == "Pepsi" })
        #expect(loadedItems.contains { $0.name == "Toothpaste" })
        
        cleanUp(fileName: fileName)
    }
    
    @Test func loadItems_shouldReturnEmptyArrayWhenDataIsCorrupted() throws {
        // Given
        let (sut, fileName) = makeSUT()
        let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        try Data("invalid data".utf8).write(to: fileURL)
        
        // When
        let loadedItems = sut.loadItems()
        
        // Then
        #expect(loadedItems.isEmpty)
        
        cleanUp(fileName: fileName)
    }
    
    @Test func saveItems_shouldOverwritePreviousItems() async throws {
        // Given
        let (sut, fileName) = makeSUT()
        sut.saveItems([Item(name: "Pepsi", quantity: 1, unitPrice: 5.4, section: .beverages)])
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // When
        let newItem = Item(name: "Cola", quantity: 2, unitPrice: 4.5, section: .beverages)
        sut.saveItems([newItem])
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        let loadedItems = sut.loadItems()
        #expect(loadedItems.count == 1)
        #expect(loadedItems[0].name == "Cola")
        
        cleanUp(fileName: fileName)
    }
}
