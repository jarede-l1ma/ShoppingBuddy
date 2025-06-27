/// Ensures a `String` value is trimmed and non-empty.
///
/// Useful for cases where item names should never be blank or just whitespace.
/// If an empty or whitespace-only string is provided, it defaults to `"Unnamed"`.
///
/// - Trims leading/trailing whitespace
/// - Falls back to `"Unnamed"` if the result is empty
///
/// ## Example:
/// ```swift
/// @NonEmptyName var name: String = "   "
/// print(name) // "Unnamed"
/// ```
@propertyWrapper
struct NonEmptyName {
    private var value: String
    
    var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unnamed" : newValue }
    }
    
    init(wrappedValue: String) {
        let trimmed = wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines)
        self.value = trimmed.isEmpty ? "Unnamed" : trimmed
    }
}

/// Ensures a `Double` value is always zero or greater.
///
/// Useful for enforcing non-negative pricing, weight, or other metrics that must be ≥ 0.
///
/// - Automatically clamps any negative values to 0.0
///
/// ## Example:
/// ```swift
/// @PriceAmount var price: Double = -3.5
/// print(price) // 0.0
/// ```
@propertyWrapper
struct PriceAmount {
    private var value: Double
    
    var wrappedValue: Double {
        get { value }
        set { value = max(0.0, newValue) }
    }
    
    init(wrappedValue: Double) {
        self.value = max(0.0, wrappedValue)
    }
}

/// Ensures an `Int` value is always positive (minimum value is 1).
///
/// This property wrapper is ideal for cases where zero or negative values are invalid,
/// such as item quantities in a shopping list.
///
/// - Automatically clamps any value below 1 to 1.
/// - Trims invalid values both on initialization and assignment.
///
/// ## Example:
/// ```swift
/// @NonZeroQuantity var quantity: Int = 0
/// print(quantity) // 1
/// ```
@propertyWrapper
struct NonZeroQuantity {
    private var value: Int
    
    var wrappedValue: Int {
        get { value }
        set { value = max(1, newValue) }
    }
    
    init(wrappedValue: Int) {
        self.value = max(1, wrappedValue)
    }
}

// MARK: - Codable

/// Conforms `NonEmptyName` to the `Codable` protocol,
/// allowing it to be encoded and decoded as a plain `String`.
///
/// This ensures compatibility when serializing models
/// that use `Capitalized` for user-friendly data handling.
extension NonEmptyName: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.init(wrappedValue: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

/// Conforms `PriceAmount` to the `Codable` protocol,
/// enabling encoding/decoding as a `Double` while preserving its validation.
///
/// This is essential for persistence of numeric values
/// like prices or measurements in external formats.
extension PriceAmount: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Double.self)
        self.init(wrappedValue: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

/// Conforms `NonZeroQuantity` to the `Codable` protocol,
/// enabling seamless encoding and decoding of its internal `Int` value.
///
/// This is useful when persisting models that use `PositiveInteger`
/// in JSON, property lists, UserDefaults, etc.
extension NonZeroQuantity: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        self.init(wrappedValue: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
