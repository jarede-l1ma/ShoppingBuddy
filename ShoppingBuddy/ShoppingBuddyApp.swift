import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseCrashlytics

@main
struct ShoppingBuddyApp: App {
    @State private var itemsStore: ItemsStore
    @State private var formVM: ItemFormViewModel
    @State private var sectionsVM: SectionsVisibilityViewModel
    @State private var alertsVM: AlertsViewModel
    @State private var authService: AuthService

    init() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings()
        db.settings = settings
        
        let store = ItemsStore()
        _itemsStore = State(initialValue: store)
        _formVM = State(initialValue: ItemFormViewModel(itemsStore: store))
        _sectionsVM = State(initialValue: SectionsVisibilityViewModel())
        _alertsVM = State(initialValue: AlertsViewModel(itemsStore: store))
        _authService = State(initialValue: AuthService())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(itemsStore)
                .environment(formVM)
                .environment(sectionsVM)
                .environment(alertsVM)
                .environment(authService)
                .task {
                    await authService.signInAnonymouslyIfNeeded()
                }
        }
    }
}
