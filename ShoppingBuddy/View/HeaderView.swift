import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("ShoppingBuddy")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            HStack {
                Button(action: {
                    withAnimation {
                        viewModel.showInputFields.toggle()
                    }
                }) {
                    Image(systemName: viewModel.showInputFields ? "xmark" : "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(viewModel.showInputFields ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                .padding(.leading, 20)
                
                Spacer()
                
                if !viewModel.showInputFields {
                    Button(action: {
                        viewModel.showDeleteAllAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.trailing, 20)
                }
            }
            .padding(.top, 10)
        }
    }
}
