import SwiftUI

struct SectionView: View {
    let section: Sections
    let isHidden: Bool
    let onToggle: () -> Void
    let cornerRadius: CGFloat = 8.0
    
    var body: some View {
        HStack {
            Text(section.localized)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            
            Spacer()
            
            Button(action: onToggle) {
                Image(systemName: isHidden ? "chevron.down" : "chevron.up")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }
        }
        .frame(maxWidth: .infinity)
        .background(section.color)
        .cornerRadius(cornerRadius, corners: isHidden ? .allCorners : [.topLeft, .topRight])
        .listRowInsets(EdgeInsets())
    }
}
