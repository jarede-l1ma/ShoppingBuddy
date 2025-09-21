import SwiftUI

@main
struct ShoppingBuddyApp: App {
    private let itemsStore: ItemsStore
    private let formVM: ItemFormViewModel
    private let sectionsVM: SectionsVisibilityViewModel
    private let alertsVM: AlertsViewModel

    init() {
        let persistence = PersistenceService()
        let store = ItemsStore(persistenceService: persistence)
        self.itemsStore = store
        self.formVM = ItemFormViewModel(itemsStore: store)
        self.sectionsVM = SectionsVisibilityViewModel()
        self.alertsVM = AlertsViewModel(itemsStore: store)
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

// MARK: - Preview

#Preview {
    let persistence = PersistenceService()
    let store = ItemsStore(persistenceService: persistence)
    let form = ItemFormViewModel(itemsStore: store)
    let sections = SectionsVisibilityViewModel()
    let alerts = AlertsViewModel(itemsStore: store)
    return ContentView(
        itemsStore: store,
        formVM: form,
        sectionsVM: sections,
        alertsVM: alerts
    )
}
