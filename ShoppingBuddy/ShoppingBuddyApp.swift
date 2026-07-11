import SwiftUI

@main
struct ShoppingBuddyApp: App {
    @State private var itemsStore: ItemsStore
    @State private var formVM: ItemFormViewModel
    @State private var sectionsVM: SectionsVisibilityViewModel
    @State private var alertsVM: AlertsViewModel

    init() {
        let persistence = PersistenceService()
        let store = ItemsStore(persistenceService: persistence)
        _itemsStore = State(initialValue: store)
        _formVM = State(initialValue: ItemFormViewModel(itemsStore: store))
        _sectionsVM = State(initialValue: SectionsVisibilityViewModel())
        _alertsVM = State(initialValue: AlertsViewModel(itemsStore: store))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                itemsStore: itemsStore,
                formVM: formVM,
                sectionsVM: sectionsVM,
                alertsVM: alertsVM
            )
        }
    }
}
