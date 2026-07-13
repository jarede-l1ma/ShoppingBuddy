import Foundation
import SwiftUI

@Observable @MainActor
final class ItemFormViewModel {
    // Form fields and state
    var editingItem: Item? = nil
    var showInputFields: Bool = false
    var selectedSection: Sections = .frozen
    var newItemName: String = ""
    var newItemQuantity: String = ""
    var newItemUnitPrice: String = ""
    
    // Validations/Warnings
    var showDuplicateItemWarning: Bool = false
    var showInvalidQuantityWarning: Bool = false
    var invalidQuantityMessage: String = ""
    var duplicateItemMessage: String = ""
    
    private let itemsStore: ItemsStore
    
    init(itemsStore: ItemsStore) {
        self.itemsStore = itemsStore
    }
    
    func addItem() {
        let itemName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if itemsStore.itemAlreadyExists(name: itemName) {
            showDuplicateItemWarning = true
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                self.showDuplicateItemWarning = false
            }
            return
        }
        
        guard let quantity = Int(newItemQuantity), quantity > 0 else {
            showInvalidQuantityWarning = true
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                self.showInvalidQuantityWarning = false
            }
            return
        }
        
        let newItem = Item(
            name: itemName,
            quantity: quantity,
            unitPrice: Double(newItemUnitPrice) ?? 0.0,
            section: selectedSection
        )
        itemsStore.addItem(newItem)
        clearForm()
    }
    
    func editItem(_ item: Item) {
        editingItem = item
        newItemName = item.name
        newItemQuantity = "\(item.quantity)"
        newItemUnitPrice = "\(item.unitPrice)"
        selectedSection = item.section
        showInputFields = true
    }
    
    func updateItem() {
        guard let editingItem = editingItem else { return }
        
        let currentPurchased = itemsStore.item(withID: editingItem.id)?.isPurchased ?? editingItem.isPurchased
        
        let updatedItem = Item(
            id: editingItem.id,
            name: newItemName,
            quantity: Int(newItemQuantity) ?? 0,
            unitPrice: Double(newItemUnitPrice) ?? 0.0,
            isPurchased: currentPurchased,
            section: selectedSection
        )
        
        itemsStore.updateItem(updatedItem)
        clearForm()
        self.editingItem = nil
    }
    
    func clearForm() {
        newItemName = ""
        newItemQuantity = ""
        newItemUnitPrice = ""
    }
    
    func showQuantityWarning(_ message: String) {
        invalidQuantityMessage = message
        withAnimation {
            showInvalidQuantityWarning = true
        }
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            withAnimation {
                self.showInvalidQuantityWarning = false
            }
        }
    }
}
