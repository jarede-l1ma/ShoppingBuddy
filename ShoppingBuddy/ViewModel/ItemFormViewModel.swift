import Foundation
import SwiftUI
import Combine

@MainActor
final class ItemFormViewModel: ObservableObject {
    // Campos e estado do formulário
    @Published var editingItem: Item? = nil
    @Published var showInputFields: Bool = false
    @Published var selectedSection: Sections = .frozen
    @Published var newItemName: String = ""
    @Published var newItemQuantity: String = ""
    @Published var newItemUnitPrice: String = ""
    
    // Validações/avisos
    @Published var showDuplicateItemWarning: Bool = false
    @Published var showInvalidQuantityWarning: Bool = false
    @Published var invalidQuantityMessage: String = ""
    @Published var duplicateItemMessage: String = ""
    
    private let itemsStore: any ItemsStoreProtocol
    
    init(itemsStore: any ItemsStoreProtocol) {
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

extension ItemFormViewModel: ItemFormViewModelProtocol {
    var editingItemPublisher: AnyPublisher<Item?, Never> {
        $editingItem.eraseToAnyPublisher()
    }
    var showInputFieldsPublisher: AnyPublisher<Bool, Never> {
        $showInputFields.eraseToAnyPublisher()
    }
    var selectedSectionPublisher: AnyPublisher<Sections, Never> {
        $selectedSection.eraseToAnyPublisher()
    }
    var newItemNamePublisher: AnyPublisher<String, Never> {
        $newItemName.eraseToAnyPublisher()
    }
    var newItemQuantityPublisher: AnyPublisher<String, Never> {
        $newItemQuantity.eraseToAnyPublisher()
    }
    var newItemUnitPricePublisher: AnyPublisher<String, Never> {
        $newItemUnitPrice.eraseToAnyPublisher()
    }
    var showDuplicateItemWarningPublisher: AnyPublisher<Bool, Never> {
        $showDuplicateItemWarning.eraseToAnyPublisher()
    }
    var showInvalidQuantityWarningPublisher: AnyPublisher<Bool, Never> {
        $showInvalidQuantityWarning.eraseToAnyPublisher()
    }
    var invalidQuantityMessagePublisher: AnyPublisher<String, Never> {
        $invalidQuantityMessage.eraseToAnyPublisher()
    }
    var duplicateItemMessagePublisher: AnyPublisher<String, Never> {
        $duplicateItemMessage.eraseToAnyPublisher()
    }
}
