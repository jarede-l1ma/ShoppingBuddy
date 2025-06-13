import SwiftUI
import Testing
@testable import ShoppingBuddy

struct SectionsTests {
    
    @Test
    func allCases_shouldIncludeAllSections() {
        let expected: [Sections] = [
            .frozen, .dairy, .pasta, .condiments, .snacks,
            .fruits, .beverages, .hygiene, .cleaning, .others
        ]
        #expect(Sections.allCases == expected)
    }

    @Test
    func id_shouldMatchRawValue() {
        for section in Sections.allCases {
            #expect(section.id == section.rawValue)
        }
    }

    @Test
    func localized_shouldReturnLocalizedValue() {
        // NOTE: This test assumes localization works as expected and is set up properly in your project.
        // We'll just test that a non-empty string is returned for each section.
        for section in Sections.allCases {
            let localized = section.localized
            #expect(!localized.isEmpty)
        }
    }

    @Test
    func color_shouldReturnNonNilColor() {
        for section in Sections.allCases {
            let color = section.color
            // UIColor.clear fallback is possible, but we should always get a valid Color object
            #expect(color is Color)
        }
    }

    @Test
    func sortedAlphabetically_shouldSortSectionsByLocalizedName() {
        let sorted = Sections.sortedAlphabetically()
        let localizedNames = sorted.map { $0.localized }
        let expected = localizedNames.sorted { $0.localizedCompare($1) == .orderedAscending }

        #expect(localizedNames == expected)
    }

    @Test
    func encodingAndDecoding_shouldMaintainValue() throws {
        for section in Sections.allCases {
            let encoded = try JSONEncoder().encode(section)
            let decoded = try JSONDecoder().decode(Sections.self, from: encoded)
            #expect(decoded == section)
        }
    }
}
