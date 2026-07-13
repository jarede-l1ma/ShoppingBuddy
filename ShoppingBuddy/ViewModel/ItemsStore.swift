import Foundation
import SwiftUI

@Observable @MainActor
final class ItemsStore {
    private(set) var items: [Item] = []
    
    private var databaseService: DatabaseServiceProtocol
    
    init(databaseService: DatabaseServiceProtocol = FirestoreService()) {
        self.databaseService = databaseService
        self.databaseService.onUpdate = { [weak self] items in
            self?.items = items
        }
    }
    
    var totalPurchasePrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func loadInitialData() {
        databaseService.startListening()
    }
    
    func saveItems() {
        // Obsolete in the context of Firestore, replaced by direct calls
    }
    
    func togglePurchasedStatus(for item: Item) {
        guard items.firstIndex(where: { $0.id == item.id }) != nil else { return }
        var updatedItem = item
        updatedItem.isPurchased.toggle()
        databaseService.saveItem(updatedItem)
    }
    
    func removeItem(_ item: Item) {
        databaseService.deleteItem(item)
    }
    
    func removeAllItems() {
        databaseService.deleteAllItems(items)
    }
    
    func itemAlreadyExists(name: String) -> Bool {
        items.contains { $0.name.lowercased() == name.lowercased() }
    }
    
    func sortItems(_ lhs: Item, _ rhs: Item) -> Bool {
        if lhs.isPurchased == rhs.isPurchased {
            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
        return !lhs.isPurchased && rhs.isPurchased
    }
    
    func addItem(_ item: Item) {
        databaseService.saveItem(item)
    }
    
    func updateItem(_ item: Item) {
        databaseService.saveItem(item)
    }
    
    func item(withID id: UUID) -> Item? {
        items.first(where: { $0.id == id })
    }
}
