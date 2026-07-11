import Foundation
import SwiftUI

@Observable @MainActor
final class SectionsVisibilityViewModel {
    var hiddenSections: [Sections] = []
    
    func toggleSectionVisibility(_ section: Sections) {
        withAnimation {
            if let index = hiddenSections.firstIndex(of: section) {
                hiddenSections.remove(at: index)
            } else {
                hiddenSections.append(section)
            }
        }
    }
}
