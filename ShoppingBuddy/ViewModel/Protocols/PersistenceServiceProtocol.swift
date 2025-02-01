protocol PersistenceServiceProtocol {
    func saveItems(_ items: [Item])
    func loadItems() -> [Item]
}
