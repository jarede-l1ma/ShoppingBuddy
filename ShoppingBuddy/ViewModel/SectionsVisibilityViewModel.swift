import Foundation
import SwiftUI
import Combine

final class SectionsVisibilityViewModel: ObservableObject {
    @Published var hiddenSections: [Sections] = []
    
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

extension SectionsVisibilityViewModel: SectionsVisibilityViewModelProtocol {
    var hiddenSectionsPublisher: AnyPublisher<[Sections], Never> { $hiddenSections.eraseToAnyPublisher() }
}
