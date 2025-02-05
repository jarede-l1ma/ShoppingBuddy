import XCTest
@testable import ShoppingBuddy

final class PersistenceServiceTests: XCTestCase {

    var persistenceService: PersistenceService!
    var mockUserDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        mockUserDefaults = UserDefaults(suiteName: #file)
        mockUserDefaults.removePersistentDomain(forName: #file)
        
        persistenceService = PersistenceService(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: #file)
        super.tearDown()
    }

    func testSaveItems() {
        let items = [
            Item(
                name: "Maçã",
                quantity: 5,
                unitPrice: 2.5,
                isPurchased: false,
                section: .fruits
            ),
            Item(
                name: "Leite",
                quantity: 2,
                unitPrice: 4.0,
                isPurchased: true,
                section: .dairy
            )
        ]
        
        persistenceService.saveItems(items)
        
        guard let savedData = mockUserDefaults.data(forKey: "savedItems") else {
            XCTFail("Dados não foram salvos no UserDefaults.")
            return
        }
        
        guard let decodedItems = try? JSONDecoder().decode([Item].self, from: savedData) else {
            XCTFail("Falha ao decodificar os dados salvos.")
            return
        }
        
        XCTAssertEqual(decodedItems, items)
    }

    func testLoadItems() {
        let items = [
            Item(
                name: "Pão",
                quantity: 1,
                unitPrice: 3.5,
                isPurchased: false,
                section: .dairy
            ),
            Item(
                name: "Ovos",
                quantity: 12,
                unitPrice: 0.5,
                isPurchased: true,
                section: .dairy
            )
        ]
        
        let encodedData = try! JSONEncoder().encode(items)
        mockUserDefaults.set(encodedData, forKey: "savedItems")
        
        let loadedItems = persistenceService.loadItems()
        
        XCTAssertEqual(loadedItems, items)
    }

    func testLoadItemsWhenNoItemsSaved() {
        mockUserDefaults.removeObject(forKey: "savedItems")
        
        let loadedItems = persistenceService.loadItems()
        
        XCTAssertTrue(loadedItems.isEmpty)
    }
}
