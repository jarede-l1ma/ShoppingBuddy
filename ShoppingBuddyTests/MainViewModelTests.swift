import Combine
import SwiftUI
import Testing
@testable import ShoppingBuddy

struct MainViewModelTests {
    // MARK: - Test Setup
    
    /// Creates a view model with a mock persistence service
    private func makeSUT(
        initialItems: [Item] = [],
        loadDelay: TimeInterval = 0
    ) -> (MainViewModel, MockPersistenceService) {
        let mockPersistence = MockPersistenceService(initialItems: initialItems)
        let viewModel = MainViewModel(persistenceService: mockPersistence)
        return (viewModel, mockPersistence)
    }
    
    // MARK: - Mock Services
    class MockPersistenceService: PersistenceServiceProtocol {
        var storedItems: [Item] = []
        var saveCount = 0
        
        init(initialItems: [Item] = []) {
            self.storedItems = initialItems
        }
        
        func saveItems(_ items: [Item]) {
            storedItems = items
            saveCount += 1
        }
        
        func loadItems() -> [Item] {
            return storedItems
        }
    }
    
    // MARK: - Test Cases
    
    @Test func initialization_shouldSetLoadingState() async {
        // Given
        let (sut, _) = makeSUT(loadDelay: 0.1)
        
        // When
        #expect(sut.isLoading == true)
        
        // Wait for loading to complete
        try? await Task.sleep(for: .seconds(0.15))
        
        // Then
        #expect(sut.isLoading == false)
    }
    
    @Test func loadInitialData_shouldLoadItemsFromPersistence() async {
        // Given
        let testItems = [
            Item(name: "Milk", quantity: 1, unitPrice: 4.99, section: .dairy)
        ]
        let (sut, _) = makeSUT(initialItems: testItems)
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(10))
        
        // Then
        #expect(sut.items.count == 1)
        #expect(sut.items.first?.name == "Milk")
    }
    
    @Test func toggleSectionVisibility_shouldAddOrRemoveSection() {
        // Given
        let (sut, _) = makeSUT()
        let testSection = Sections.condiments
        
        // When
        sut.toggleSectionVisibility(testSection)
        
        // Then
        #expect(sut.hiddenSections.contains(testSection))
        
        // When - Toggle again
        sut.toggleSectionVisibility(testSection)
        
        // Then
        #expect(!sut.hiddenSections.contains(testSection))
    }
    
    @Test func addItem_shouldAppendNewItemAndSave() {
        // Given
        let (sut, persistence) = makeSUT()
        sut.newItemName = "Bread"
        sut.newItemQuantity = "2"
        sut.newItemUnitPrice = "3.99"
        sut.selectedSection = .dairy
        
        // When
        sut.addItem()
        
        // Then
        #expect(sut.items.count == 1)
        #expect(sut.items[0].name == "Bread")
        #expect(persistence.saveCount == 1)
        #expect(sut.newItemName.isEmpty) // Form should be cleared
    }
    
    @Test func addItem_shouldShowWarningForDuplicate() {
        // Given
        let existingItem = Item(name: "Eggs", quantity: 12, unitPrice: 5.99, section: .dairy)
        let (sut, _) = makeSUT(initialItems: [existingItem])
        sut.newItemName = "Eggs" // Duplicate name
        sut.newItemQuantity = "1"
        sut.newItemUnitPrice = "1.99"
        
        // When
        sut.addItem()
        
        // Then
        #expect(sut.showDuplicateItemWarning)
        #expect(sut.items.count == 1) // Should not add duplicate
    }
    
    @Test func togglePurchasedStatus_shouldUpdateItemAndSave() async {
        // Given
        let testID = UUID()
        let testItem = Item(id: testID, name: "Coffee", quantity: 1, unitPrice: 8.99, section: .beverages)
        let (sut, persistence) = makeSUT(initialItems: [testItem])
        
        try? await Task.sleep(for: .milliseconds(10))
        
        // When
        sut.togglePurchasedStatus(for: testItem)
        
        // Then
        guard let updatedItem = sut.items.first(where: { $0.id == testID }) else {
            Issue.record("Item with ID \(testID) not found")
            return
        }
        
        #expect(updatedItem.isPurchased == !testItem.isPurchased)
        #expect(persistence.saveCount == 1)
    }
    
    @Test func editItem_shouldPopulateFormFields() {
        // Given
        let testItem = Item(name: "Yogurt", quantity: 4, unitPrice: 1.25, section: .dairy)
        let (sut, _) = makeSUT(initialItems: [testItem])
        
        // When
        sut.editItem(testItem)
        
        // Then
        #expect(sut.editingItem?.id == testItem.id)
        #expect(sut.newItemName == "Yogurt")
        #expect(sut.newItemQuantity == "4")
        #expect(sut.newItemUnitPrice == "1.25")
        #expect(sut.selectedSection == .dairy)
        #expect(sut.showInputFields)
    }
    
    @Test func updateItem_shouldModifyExistingItemAndSave() {
        // Given
        let testItem = Item(name: "Old", quantity: 1, unitPrice: 1.0, section: .others)
        let (sut, persistence) = makeSUT(initialItems: [testItem])
        sut.editItem(testItem)
        
        // Prepare changes
        sut.newItemName = "New"
        sut.newItemQuantity = "2"
        sut.newItemUnitPrice = "2.0"
        sut.selectedSection = .beverages
        
        // When
        sut.updateItem()
        
        // Then
        #expect(sut.items[0].name == "New")
        #expect(sut.items[0].quantity == 2)
        #expect(sut.items[0].unitPrice == 2.0)
        #expect(sut.items[0].section == .beverages)
        #expect(persistence.saveCount == 1)
        #expect(sut.editingItem == nil) // Should clear editing state
    }
    
    @Test func removeItem_shouldDeleteItemAndSave() async {
        // Given
        let testItem = Item(name: "To Delete", quantity: 1, unitPrice: 1.0, section: .others)
        let (sut, persistence) = makeSUT(initialItems: [testItem])
        try? await Task.sleep(for: .milliseconds(10))
        
        // When
        sut.removeItem(testItem)
        
        // Then
        #expect(sut.items.isEmpty)
        #expect(persistence.saveCount == 1)
    }
    
    @Test func confirmDeleteItem_shouldSetPendingDeletion() {
        // Given
        let testItem = Item(name: "Pending", quantity: 1, unitPrice: 1.0, section: .others)
        let (sut, _) = makeSUT(initialItems: [testItem])
        
        // When
        sut.confirmDeleteItem(testItem)
        
        // Then
        #expect(sut.itemToDelete?.id == testItem.id)
        #expect(sut.showDeleteAlert)
    }
    
    @Test func deleteItem_shouldRemovePendingItemAndSave() async {
        // Given
        let testItem = Item(name: "To Remove", quantity: 1, unitPrice: 1.0, section: .others)
        let (sut, persistence) = makeSUT(initialItems: [testItem])
        sut.itemToDelete = testItem
        try? await Task.sleep(for: .milliseconds(10))
        
        // When
        sut.deleteItem()
        
        // Then
        #expect(sut.items.isEmpty)
        #expect(persistence.saveCount == 1)
        #expect(sut.itemToDelete == nil)
        #expect(!sut.showDeleteAlert)
    }
    
    @Test func totalPurchasePrice_shouldCalculateCorrectSum() async {
        // Given
        let items = [
            Item(name: "A", quantity: 2, unitPrice: 5.0, section: .others),
            Item(name: "B", quantity: 3, unitPrice: 2.0, section: .others)
        ]
        let (sut, _) = makeSUT(initialItems: items)
        try? await Task.sleep(for: .milliseconds(10))
        
        // Then (2*5 + 3*2 = 10 + 6 = 16.0)
        #expect(sut.totalPurchasePrice == 16.0)
    }
    
    @Test func formatCurrency_shouldFormatCorrectly() {
        // Given
        let (sut, _) = makeSUT()
        
        // Then
        #expect(sut.formatCurrency(10.50) == "R$ 10,50")
        #expect(sut.formatCurrency(0.99) == "R$ 0,99")
        #expect(sut.formatCurrency(1000) == "R$ 1.000,00")
    }
    
    @Test func itemAlreadyExists_shouldDetectDuplicates() async {
        // Given
        let items = [
            Item(name: "Existing", quantity: 1, unitPrice: 1.0, section: .others)
        ]
        let (sut, _) = makeSUT(initialItems: items)
        try? await Task.sleep(for: .milliseconds(10))
        // Then
        #expect(sut.itemAlreadyExists(name: "existing")) // Case-insensitive
        #expect(sut.itemAlreadyExists(name: "EXISTING"))
        #expect(!sut.itemAlreadyExists(name: "New Item"))
    }
    
    @Test func updateItem_shouldModifyExistingItemAndSave() async {
        // Given
        let testItem = Item(name: "Old", quantity: 1, unitPrice: 1.0, section: .others)
        let (sut, persistence) = makeSUT(initialItems: [testItem])
        
        // Wait for loadInitialData (which uses DispatchQueue.main.async)
        try? await Task.sleep(for: .milliseconds(10))

        sut.editItem(testItem)

        sut.newItemName = "New"
        sut.newItemQuantity = "2"
        sut.newItemUnitPrice = "2.0"
        sut.selectedSection = .beverages

        // When
        sut.updateItem()

        // Then
        #expect(sut.items[0].name == "New")
        #expect(sut.items[0].quantity == 2)
        #expect(sut.items[0].unitPrice == 2.0)
        #expect(sut.items[0].section == .beverages)
        #expect(persistence.saveCount == 1)
        #expect(sut.editingItem == nil)
    }
    
    @Test func sortItems_shouldPrioritizeUnpurchased() {
        // Given
        let (sut, _) = makeSUT()
        let unpurchased = Item(name: "A", quantity: 1, unitPrice: 1.0, section: .others)
        let purchased = Item(name: "B", quantity: 1, unitPrice: 1.0, isPurchased: true, section: .others)
        
        // When
        let result1 = sut.sortItems(unpurchased, purchased) // A vs B
        let result2 = sut.sortItems(purchased, unpurchased) // B vs A
        
        // Then
        #expect(result1 == true)  // Unpurchased should come before purchased
        #expect(result2 == false)
    }
    
    @Test func sortItems_shouldSortAlphabeticallyWhenEqualStatus() {
        // Given
        let (sut, _) = makeSUT()
        let itemA = Item(name: "Apple", quantity: 1, unitPrice: 1.0, section: .others)
        let itemZ = Item(name: "Zucchini", quantity: 1, unitPrice: 1.0, section: .others)
        
        // When
        let result1 = sut.sortItems(itemA, itemZ) // Apple vs Zucchini
        let result2 = sut.sortItems(itemZ, itemA) // Zucchini vs Apple
        
        // Then
        #expect(result1 == true)  // Apple comes before Zucchini
        #expect(result2 == false)
    }
    
    @Test func clearForm_shouldResetInputFields() async {
        // Given
        let (sut, _) = makeSUT()
        sut.newItemName = "Test"
        sut.newItemQuantity = "5"
        sut.newItemUnitPrice = "10.50"
        sut.selectedSection = .dairy
        
        try? await Task.sleep(for: .milliseconds(10))
        
        // When
        sut.clearForm()
        
        // Then
        #expect(sut.newItemName.isEmpty)
        #expect(sut.newItemQuantity.isEmpty)
        #expect(sut.newItemUnitPrice.isEmpty)
        #expect(sut.selectedSection == .dairy)
    }
}
