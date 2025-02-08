import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Text(CommonsStrings.appName.localized)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
        }
        .transition(.opacity)
    }
}
