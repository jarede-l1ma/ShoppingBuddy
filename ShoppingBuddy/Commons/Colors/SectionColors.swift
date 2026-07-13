import SwiftUI

/// Fixed palette matching your image (Pastel: Sunrise)
/// Kept for visualization and as a subtle fallback, but the app will use the dynamic gradient.
private let pastelSunrisePalette: [Color] = [
    Color(hex: "#FCF0C4"), // Beverages
    Color(hex: "#FBE3C6"), // Cleaning
    Color(hex: "#FBD7C8"), // Dairy
    Color(hex: "#FACDCA"), // Frozen
    Color(hex: "#FACCD4"), // Fruits
    Color(hex: "#FACCE5"), // Hygiene
    Color(hex: "#F8CAFA"), // Others
    Color(hex: "#E0C8FB"), // Pasta
    Color(hex: "#C6C8FB"), // Condiments
    Color(hex: "#C4E1FC")  // Snacks
]

struct SectionColors: View {
    let sectionNames: [String]

    var body: some View {
        VStack(spacing: 0) {
            Text("Pastel: Sunrise")
                .font(.headline)
                .padding(.vertical, 8)

            ForEach(Array(sectionNames.enumerated()), id: \.element) { index, name in
                let color = pastelSunrisePalette[safe: index] ?? pastelSunrisePalette.last ?? .gray
                HStack {
                    Text(name)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Spacer()
                    Text(color.hexDescription)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(color)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 4)
        .padding()
    }
}

// MARK: - Public API to provide dynamic colors to application Views
extension SectionColors {
    /// Dynamic color based on the index and the total number of visible sections.
    /// Generates a smooth transition (gradient) using HSB anchors.
    static func colorForVisibleSection(at index: Int, total: Int) -> Color {
        gradientColor(for: index, total: total)
    }
    
    /// Returns a color via a smooth gradient between three anchors (pastel yellow → pastel pink/lilac → pastel blue).
    static func gradientColor(for index: Int, total: Int) -> Color {
        let anchors: [(hue: Double, sat: Double, bright: Double)] = [
            (0.13, 0.22, 0.99), // pastel yellow
            (0.95, 0.18, 0.98), // pastel pink/lilac
            (0.58, 0.22, 0.99)  // pastel blue
        ]
        
        let totalSteps = max(total - 1, 1)
        let t = Double(index) / Double(totalSteps)
        
        if t < 0.5 {
            return interpolateHSB(from: anchors[0], to: anchors[1], fraction: t * 2)
        } else {
            return interpolateHSB(from: anchors[1], to: anchors[2], fraction: (t - 0.5) * 2)
        }
    }
    
    /// Discreet fallback by index (cycles through the fixed palette).
    static func paletteColor(forIndex index: Int) -> Color {
        pastelSunrisePalette[safe: index % max(pastelSunrisePalette.count, 1)] ?? .gray
    }
    
    private static func interpolateHSB(
        from: (hue: Double, sat: Double, bright: Double),
        to: (hue: Double, sat: Double, bright: Double),
        fraction: Double
    ) -> Color {
        var deltaH = to.hue - from.hue
        if deltaH > 0.5 { deltaH -= 1 }
        if deltaH < -0.5 { deltaH += 1 }
        let h = from.hue + deltaH * fraction
        let s = from.sat + (to.sat - from.sat) * fraction
        let b = from.bright + (to.bright - from.bright) * fraction
        return Color(hue: (h < 0 ? h + 1 : h), saturation: s, brightness: b)
    }
}

// MARK: - Helpers

extension Color {
    /// Color init from HEX string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255,
                            int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
    
    /// HEX string for the color
    var hexDescription: String {
        #if canImport(UIKit)
        typealias NativeColor = UIColor
        #elseif canImport(AppKit)
        typealias NativeColor = NSColor
        #endif

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        NativeColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return String(format: "#%02X%02X%02X",
                      Int(red * 255),
                      Int(green * 255),
                      Int(blue * 255))
    }
}

extension Collection {
    /// Safe array subscript
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
