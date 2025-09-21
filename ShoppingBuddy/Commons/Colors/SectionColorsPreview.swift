import SwiftUI

struct SectionColorsPreview: View {
    let sectionNames: [String]
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Pastel Gradient")
                .font(.headline)
                .padding(.vertical, 8)
            
            ForEach(Array(sectionNames.enumerated()), id: \.element) { index, name in
                HStack {
                    Text(name)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "#%02X%02X%02X",
                                Int(pastelColorForSection(at: index, total: sectionNames.count).uiColor.redValue*255),
                                Int(pastelColorForSection(at: index, total: sectionNames.count).uiColor.greenValue*255),
                                Int(pastelColorForSection(at: index, total: sectionNames.count).uiColor.blueValue*255)
                    ))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(pastelColorForSection(at: index, total: sectionNames.count))
            }

            Divider()
                .padding(.vertical, 16)
            
            Text("Vibrant Gradient")
                .font(.headline)
                .padding(.vertical, 8)
            
            ForEach(Array(sectionNames.enumerated()), id: \.element) { index, name in
                HStack {
                    Text(name)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "#%02X%02X%02X",
                                Int(vibrantColorForSection(at: index, total: sectionNames.count).uiColor.redValue*255),
                                Int(vibrantColorForSection(at: index, total: sectionNames.count).uiColor.greenValue*255),
                                Int(vibrantColorForSection(at: index, total: sectionNames.count).uiColor.blueValue*255)
                    ))
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
                .background(vibrantColorForSection(at: index, total: sectionNames.count))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(radius: 4)
        .padding()
    }
}

// Helpers to extract RGB for HEX formatting
extension Color {
    var uiColor: UIColor {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = CGFloat((hexNumber & 0xFF0000) >> 16)/255.0
        let g = CGFloat((hexNumber & 0x00FF00) >> 8)/255.0
        let b = CGFloat(hexNumber & 0x0000FF)/255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
extension UIColor {
    var redValue: CGFloat { cgColor.components?[safe: 0] ?? 0 }
    var greenValue: CGFloat { cgColor.components?[safe: 1] ?? 0 }
    var blueValue: CGFloat { cgColor.components?[safe: 2] ?? 0 }
}
extension Collection {
    subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}

#Preview("Section Color Palettes") {
    SectionColorsPreview(sectionNames: [
        "Beverages", "Cleaning", "Dairy", "Frozen", "Fruits", "Hygiene", "Others", "Pasta", "Condiments", "Snacks"
    ])
}
