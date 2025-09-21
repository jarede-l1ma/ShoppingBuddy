import Foundation
import Combine

@MainActor 
protocol ItemFormViewModelProtocol: ObservableObject {
    // Propriedades espelhadas
    var editingItem: Item? { get set }
    var showInputFields: Bool { get set }
    var selectedSection: Sections { get set }
    var newItemName: String { get set }
    var newItemQuantity: String { get set }
    var newItemUnitPrice: String { get set }
    var showDuplicateItemWarning: Bool { get set }
    var showInvalidQuantityWarning: Bool { get set }
    var invalidQuantityMessage: String { get set }
    var duplicateItemMessage: String { get set }
    
    // Publishers
    var editingItemPublisher: AnyPublisher<Item?, Never> { get }
    var showInputFieldsPublisher: AnyPublisher<Bool, Never> { get }
    var selectedSectionPublisher: AnyPublisher<Sections, Never> { get }
    var newItemNamePublisher: AnyPublisher<String, Never> { get }
    var newItemQuantityPublisher: AnyPublisher<String, Never> { get }
    var newItemUnitPricePublisher: AnyPublisher<String, Never> { get }
    var showDuplicateItemWarningPublisher: AnyPublisher<Bool, Never> { get }
    var showInvalidQuantityWarningPublisher: AnyPublisher<Bool, Never> { get }
    var invalidQuantityMessagePublisher: AnyPublisher<String, Never> { get }
    var duplicateItemMessagePublisher: AnyPublisher<String, Never> { get }
    
    // Ações
    func addItem()
    func editItem(_ item: Item)
    func updateItem()
    func clearForm()
    func showQuantityWarning(_ message: String)
}
