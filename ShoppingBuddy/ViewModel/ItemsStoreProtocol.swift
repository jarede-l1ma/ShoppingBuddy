import Foundation
import Combine

@MainActor
protocol ItemsStoreProtocol: ObservableObject {
    // Publishers de estado
    var itemsPublisher: AnyPublisher<[Item], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    
    // Leitura derivada
    var totalPurchasePrice: Double { get }
    
    // Operations
    func loadInitialData()
    func saveItems()
    func togglePurchasedStatus(for item: Item)
    func removeItem(_ item: Item)
    func itemAlreadyExists(name: String) -> Bool
    func sortItems(_ lhs: Item, _ rhs: Item) -> Bool
    
    // Direct item mutation (for the form)
    func addItem(_ item: Item)
    func updateItem(_ item: Item)
    func item(withID id: UUID) -> Item?
}
