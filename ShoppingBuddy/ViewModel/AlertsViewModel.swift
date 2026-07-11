import Foundation
import SwiftUI

@Observable @MainActor
final class AlertsViewModel {
    var showDeleteAllAlert: Bool = false
    var showDeleteAlert: Bool = false
    var itemToDelete: Item? = nil
    
    private let itemsStore: ItemsStore
    
    init(itemsStore: ItemsStore) {
        self.itemsStore = itemsStore
    }

    func confirmDeleteItem(_ item: Item) {
        itemToDelete = item
        showDeleteAlert = true
    }
    
    func deleteItem() {
        guard let itemToDelete = itemToDelete else { return }
        itemsStore.removeItem(itemToDelete)
        self.itemToDelete = nil
        self.showDeleteAlert = false
    }
}
