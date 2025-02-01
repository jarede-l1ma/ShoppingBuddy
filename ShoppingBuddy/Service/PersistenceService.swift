import Foundation

final class PersistenceService: PersistenceServiceProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveItems(_ items: [Item]) {
        if let encodedData = try? JSONEncoder().encode(items) {
            userDefaults.set(encodedData, forKey: "savedItems")
        }
    }
    
    func loadItems() -> [Item] {
        guard let savedData = userDefaults.data(forKey: "savedItems"),
              let decodedItems = try? JSONDecoder().decode([Item].self, from: savedData) else {
            return []
        }
        return decodedItems
    }
}
