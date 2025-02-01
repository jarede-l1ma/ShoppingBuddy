import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var items: [Item] = []
    @Published var hiddenSections: [ShoppingSection] = []
    @Published var isLoading: Bool = true
    @Published var showDeleteAllAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var itemToDelete: Item? = nil
    @Published var editingItem: Item? = nil
    @Published var showInputFields: Bool = false
    @Published var selectedSection: ShoppingSection = .frozen
    @Published var newItemName: String = ""
    @Published var newItemQuantity: String = ""
    @Published var newItemUnitPrice: String = ""
    @Published var showDuplicateItemWarning: Bool = false
    
    // MARK: - Dependencies
    private let persistenceService: PersistenceServiceProtocol
    
    // MARK: - Computed Properties
    var totalPurchasePrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    // MARK: - Initialization
    init(persistenceService: PersistenceServiceProtocol = PersistenceService()) {
        self.persistenceService = persistenceService
        loadInitialData()
    }
    
    // MARK: - Public Methods
    func toggleSectionVisibility(_ section: ShoppingSection) {
        withAnimation {
            if let index = hiddenSections.firstIndex(of: section) {
                hiddenSections.remove(at: index)
            } else {
                hiddenSections.append(section)
            }
        }
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: value)) ?? "R$ 0,00"
    }
    
    func addItem() {
        let itemName = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if itemAlreadyExists(name: itemName) {
            // Trigger animation and show tooltip
            showDuplicateItemWarning = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showDuplicateItemWarning = false
            }
            return
        }
        
        guard let quantity = Int(newItemQuantity) else { return }
        let newItem = Item(
            name: itemName,
            quantity: quantity,
            unitPrice: Double(newItemUnitPrice) ?? 0.0,
            section: selectedSection
        )
        withAnimation {
            items.append(newItem)
        }
        clearForm()
        saveItems()
    }
    
    func togglePurchasedStatus(for item: Item) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        withAnimation(.spring()) {
            items[index].isPurchased.toggle()
            saveItems()
        }
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
        guard let editingItem = editingItem,
              let index = items.firstIndex(where: { $0.id == editingItem.id }) else { return }
        
        let updatedItem = Item(
            name: newItemName,
            quantity: Int(newItemQuantity) ?? 0,
            unitPrice: Double(newItemUnitPrice) ?? 0.0,
            isPurchased: items[index].isPurchased,
            section: selectedSection
        )
        withAnimation {
            items[index] = updatedItem
        }
        clearForm()
        saveItems()
        self.editingItem = nil
    }
    
    // MARK: - Private Methods
    private func loadInitialData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isLoading = false
                self.items = self.persistenceService.loadItems()
            }
        }
    }
    
    func sortItems(_ lhs: Item, _ rhs: Item) -> Bool {
        if lhs.isPurchased == rhs.isPurchased {
            return lhs.name < rhs.name
        }
        return !lhs.isPurchased && rhs.isPurchased
    }
    
    func saveItems() {
        persistenceService.saveItems(items)
    }
    
    func clearForm() {
        newItemName = ""
        newItemQuantity = ""
        newItemUnitPrice = ""
    }

    func removeItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            withAnimation {
                items.remove(at: index)
                saveItems()
            }
        }
    }
    
    func confirmDeleteItem(_ item: Item) {
        itemToDelete = item
        showDeleteAlert = true
    }
    
    func deleteItem() {
        guard let itemToDelete = itemToDelete else { return }
        if let index = items.firstIndex(where: { $0.id == itemToDelete.id }) {
            withAnimation {
                items.remove(at: index)
                saveItems()
            }
        }
        self.itemToDelete = nil
    }
    
    func itemAlreadyExists(name: String) -> Bool {
        return items.contains { $0.name.lowercased() == name.lowercased() }
    }
}
