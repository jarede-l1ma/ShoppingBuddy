import Foundation
import Combine

@MainActor
protocol AlertsViewModelProtocol: ObservableObject {
    var showDeleteAllAlert: Bool { get set }
    var showDeleteAlert: Bool { get set }
    var itemToDelete: Item? { get set }
    
    var showDeleteAllAlertPublisher: AnyPublisher<Bool, Never> { get }
    var showDeleteAlertPublisher: AnyPublisher<Bool, Never> { get }
    var itemToDeletePublisher: AnyPublisher<Item?, Never> { get }
    
    func confirmDeleteItem(_ item: Item)
    func deleteItem()
}
