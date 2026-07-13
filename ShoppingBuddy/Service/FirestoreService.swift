import FirebaseFirestore
import FirebaseCore
import Combine
import FirebaseAuth

protocol DatabaseServiceProtocol {
    var onUpdate: (([Item]) -> Void)? { get set }
    func startListening()
    func stopListening()
    func saveItem(_ item: Item)
    func deleteItem(_ item: Item)
    func deleteAllItems(_ items: [Item])
}

/// Service responsible for synchronizing shopping list items in real time with Firestore.
final class FirestoreService: DatabaseServiceProtocol {
    private let db = Firestore.firestore()
    
    private var collectionRef: CollectionReference {
        if let uid = Auth.auth().currentUser?.uid {
            return db.collection("users").document(uid).collection("shopping_list")
        } else {
            // Fallback (deve ser evitado com o AuthService garantindo o login)
            return db.collection("fallback_list")
        }
    }
    
    private var listenerRegistration: ListenerRegistration?
    
    // Since PersistenceServiceProtocol assumes punctual synchronous/asynchronous operations,
    // we will work around this by delegating actions. Ideally ItemsStore would be rewritten,
    // but to maintain compatibility with the view and current architecture without major friction:
    
    var onUpdate: (([Item]) -> Void)?
    
    func startListening() {
        listenerRegistration = collectionRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                self.onUpdate?([]) // Clears the list in case of a critical permission error
                return
            }
            let items: [Item] = documents.compactMap { doc in
                do {
                    return try doc.data(as: Item.self)
                } catch {
                    print("Error decoding item: \(error)")
                    return nil
                }
            }
            self.onUpdate?(items)
        }
    }
    
    func stopListening() {
        listenerRegistration?.remove()
    }
    
    // MARK: - PersistenceServiceProtocol
    // We can ignore the general `saveItems` since we will save individually.
    // But to fulfill the protocol (or in case it does batch save):
    func saveItems(_ items: [Item]) {
        // In a real-time flow, saving the entire list is an anti-pattern unless it's a batch.
        // `ItemsStore` will call the granular functions instead of this one.
    }
    
    func loadItems() -> [Item] {
        // This is called only initially, but SnapshotListener will handle loading.
        return []
    }
    
    // Granular Functions
    func saveItem(_ item: Item) {
        do {
            try collectionRef.document(item.id.uuidString).setData(from: item)
        } catch {
            print("Error writing item to Firestore: \(error)")
        }
    }
    
    func deleteItem(_ item: Item) {
        collectionRef.document(item.id.uuidString).delete()
    }
    
    func deleteAllItems(_ items: [Item]) {
        let batch = db.batch()
        for item in items {
            let docRef = collectionRef.document(item.id.uuidString)
            batch.deleteDocument(docRef)
        }
        batch.commit()
    }
}
