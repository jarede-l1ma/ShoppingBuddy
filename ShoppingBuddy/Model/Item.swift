import Foundation

struct Item: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var quantity: Int
    var unitPrice: Double
    var isPurchased: Bool
    var section: Sections
    
    init(
        id: UUID = UUID(),
        name: String,
        quantity: Int,
        unitPrice: Double,
        isPurchased: Bool = false,
        section: Sections
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.isPurchased = isPurchased
        self.section = section
    }
    
    var totalPrice: Double {
        Double(quantity) * unitPrice
    }
}
