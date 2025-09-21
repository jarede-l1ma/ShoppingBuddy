import Foundation
import SwiftUI
import Combine

@MainActor
final class ItemsStore: ObservableObject {
    @Published private(set) var items: [Item] = []
    @Published private(set) var isLoading: Bool = true
    
    private let persistenceService: PersistenceServiceProtocol
    
    init(persistenceService: PersistenceServiceProtocol) {
        self.persistenceService = persistenceService
    }
}

extension ItemsStore: ItemsStoreProtocol {
    var itemsPublisher: AnyPublisher<[Item], Never> { $items.eraseToAnyPublisher() }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { $isLoading.eraseToAnyPublisher() }
    var totalPurchasePrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
    
    func loadInitialData() {
        Task {
            let loadedItems = await Task.detached(priority: .userInitiated) { [persistenceService] in
                persistenceService.loadItems()
            }.value
            
            withAnimation {
                self.items = loadedItems
                self.isLoading = false
            }
        }
    }
    
    func saveItems() {
        persistenceService.saveItems(items)
    }
    
    func togglePurchasedStatus(for item: Item) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        withAnimation(.spring()) {
            items[index].isPurchased.toggle()
            saveItems()
        }
    }
    
    func removeItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            withAnimation {
                items.remove(at: index)
                saveItems()
            }
        }
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
        withAnimation {
            items.append(item)
        }
        saveItems()
    }
    
    func updateItem(_ item: Item) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        withAnimation {
            items[index] = item
        }
        saveItems()
    }
    
    func item(withID id: UUID) -> Item? {
        items.first(where: { $0.id == id })
    }
}
