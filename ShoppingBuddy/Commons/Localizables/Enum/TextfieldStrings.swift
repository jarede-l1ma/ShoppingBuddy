enum TextfieldStrings: String {
    case productName
    case quantityItem
    case unitValue
    case itemAlreadyExists
    case section

    var localized: String {
        String(localized: String.LocalizationValue(self.rawValue), table: "TextfieldStrings")
    }
}
