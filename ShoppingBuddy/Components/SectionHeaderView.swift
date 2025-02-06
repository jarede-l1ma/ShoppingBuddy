import SwiftUI

struct SectionHeaderView: View {
    let section: Sections
    let isHidden: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Text(section.localized)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.vertical, 8)
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
        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 10))
        .listRowInsets(EdgeInsets())
    }
}
