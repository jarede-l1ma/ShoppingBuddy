import Foundation
import Testing
@testable import ShoppingBuddy

struct ItemTests {
    // MARK: - Test Cases
    
    @Test func item_shouldHaveCorrectDefaultValues() {
        let item = Item(name: "Milk", quantity: 2, unitPrice: 3.99, section: .dairy)

        #expect(item.name == "Milk")
        #expect(item.quantity == 2)
        #expect(item.unitPrice == 3.99)
        #expect(item.isPurchased == false)
        #expect(item.section == .dairy)
    }
    
    @Test func item_shouldCalculateTotalPriceCorrectly() {
        let item = Item(name: "Apples", quantity: 5, unitPrice: 0.99, section: .fruits)
        
        #expect(item.totalPrice == 4.95)
    }
    
    @Test func items_withSameProperties_shouldBeEqual() {
        let fixedUUID = UUID()
        let item1 = Item(id: fixedUUID, name: "Bread", quantity: 1, unitPrice: 2.99, section: .dairy)
        let item2 = Item(id: fixedUUID, name: "Bread", quantity: 1, unitPrice: 2.99, section: .dairy)
        
        #expect(item1 == item2)
    }
    
    @Test func items_withDifferentIDs_shouldNotBeEqual() {
        let item1 = Item(id: UUID(), name: "Eggs", quantity: 12, unitPrice: 3.99, section: .dairy)
        let item2 = Item(id: UUID(), name: "Eggs", quantity: 12, unitPrice: 3.99, section: .dairy)
        
        #expect(item1 != item2)
    }
    
    @Test func item_shouldProperlyEncodeAndDecode() throws {
        let originalItem = Item(
            id: UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!,
            name: "Coffee",
            quantity: 1,
            unitPrice: 8.99,
            isPurchased: true,
            section: .beverages
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(originalItem)
        
        let decoder = JSONDecoder()
        let decodedItem = try decoder.decode(Item.self, from: data)
        
        #expect(decodedItem == originalItem)
        #expect(decodedItem.id == originalItem.id)
        #expect(decodedItem.name == "Coffee")
        #expect(decodedItem.totalPrice == 8.99)
    }
    
    @Test func item_shouldNotBeEqual_whenPropertiesDiffer() {
        let baseItem = Item(name: "Yogurt", quantity: 4, unitPrice: 1.25, section: .dairy)
        
        #expect(baseItem != Item(name: "Different", quantity: 4, unitPrice: 1.25, section: .dairy))
        #expect(baseItem != Item(name: "Yogurt", quantity: 2, unitPrice: 1.25, section: .dairy))
        #expect(baseItem != Item(name: "Yogurt", quantity: 4, unitPrice: 2.50, section: .dairy))
        #expect(baseItem != Item(name: "Yogurt", quantity: 4, unitPrice: 1.25, section: .frozen))
        #expect(baseItem != Item(name: "Yogurt", quantity: 4, unitPrice: 1.25, isPurchased: true, section: .dairy))
    }
    
    @Test func item_initWithDefaultParameters() {
        let item = Item(name: "Water", quantity: 1, unitPrice: 1.99, section: .beverages)
        
        #expect(item.isPurchased == false)
        #expect(item.id != UUID()) // Should be unique
    }
}
