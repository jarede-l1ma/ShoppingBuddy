enum ItemRowStrings: String {
    case quantity
    case unitValue
    case total
    case purchaseTotal
    
    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "ItemRowStrings")
    }
}
