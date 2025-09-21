import Foundation
import Combine

protocol SectionsVisibilityViewModelProtocol: ObservableObject {
    var hiddenSections: [Sections] { get set }
    var hiddenSectionsPublisher: AnyPublisher<[Sections], Never> { get }
    func toggleSectionVisibility(_ section: Sections)
}
