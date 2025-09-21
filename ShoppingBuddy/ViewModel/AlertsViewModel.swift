import Foundation
import Combine
import SwiftUI

@MainActor
final class AlertsViewModel: ObservableObject {
    @Published var showDeleteAllAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var itemToDelete: Item? = nil
    
    private let itemsStore: any ItemsStoreProtocol
    
    init(itemsStore: any ItemsStoreProtocol) {
        self.itemsStore = itemsStore
    }
}

extension AlertsViewModel: AlertsViewModelProtocol {
    var showDeleteAllAlertPublisher: AnyPublisher<Bool, Never> { $showDeleteAllAlert.eraseToAnyPublisher() }
    var showDeleteAlertPublisher: AnyPublisher<Bool, Never> { $showDeleteAlert.eraseToAnyPublisher() }
    var itemToDeletePublisher: AnyPublisher<Item?, Never> { $itemToDelete.eraseToAnyPublisher() }
    
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
