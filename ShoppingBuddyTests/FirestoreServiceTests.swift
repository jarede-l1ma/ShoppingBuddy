import Testing
import Foundation
import FirebaseCore
import FirebaseFirestore
@testable import ShoppingBuddy

@Suite("Firestore Service Integration Tests")
struct FirestoreServiceTests {
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    
    @Test("Save Item and Check Listener", arguments: [
        Item(name: "Integration Test", quantity: 1, unitPrice: 10.0, section: .others)
    ])
    func testSaveAndListen(testItem: Item) async throws {
        let service = FirestoreService()
        
        let receivedItems = await withCheckedContinuation { continuation in
            var hasResumed = false
            
            service.onUpdate = { items in
                guard !hasResumed else { return }
                
                if items.contains(where: { $0.id == testItem.id }) {
                    hasResumed = true
                    continuation.resume(returning: items)
                }
            }
            
            service.startListening()
            
            service.saveItem(testItem)
        }
        
        #expect(receivedItems.contains(where: { $0.id == testItem.id }))
        
        service.deleteItem(testItem)
        service.stopListening()
    }
    
    @Test("Delete Existing Item")
    func testDeleteItem() async throws {
        let service = FirestoreService()
        let testItem = Item(name: "Test Delete", quantity: 1, unitPrice: 5.0, section: .fruits)
        
        service.saveItem(testItem)
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        service.deleteItem(testItem)
        
        let wasDeleted = await withCheckedContinuation { continuation in
            var hasResumed = false
            
            service.onUpdate = { items in
                guard !hasResumed else { return }
                
                if !items.contains(where: { $0.id == testItem.id }) {
                    hasResumed = true
                    continuation.resume(returning: true)
                }
            }
            
            service.startListening()
        }
        
        #expect(wasDeleted == true)
        
        service.stopListening()
    }
}
