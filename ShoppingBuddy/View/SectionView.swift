import SwiftUI

struct SectionView: View {
    let section: Sections
    let color: Color
    @Environment(SectionsVisibilityViewModel.self) private var sectionsVM
    let cornerRadius: CGFloat = 8.0
    
    private var isHidden: Bool {
        sectionsVM.hiddenSections.contains(section)
    }

    var body: some View {
        HStack {
            Text(section.icon)
                .padding(.leading, 10)
                .shadow(color: .white, radius: 6)
            Text(section.localized)
                .font(.headline)
                .foregroundStyle(.black)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            
            Spacer()
            
            Button(action: {
                sectionsVM.toggleSectionVisibility(section)
            }) {
                Image(systemName: isHidden ? "chevron.down" : "chevron.up")
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
            .accessibilityLabel(isHidden ? "Expandir seção \(section.localized)" : "Recolher seção \(section.localized)")
        }
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(cornerRadius, corners: isHidden ? .allCorners : [.topLeft, .topRight])
        .listRowInsets(EdgeInsets())
    }
}

