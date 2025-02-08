import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                mainContentView
                    .opacity(viewModel.isLoading ? 0 : 1)
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(CommonsStrings.appName.localized)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            viewModel.showInputFields.toggle()
                        }
                    }) {
                        Image(systemName: viewModel.showInputFields ? "xmark" : "plus")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(viewModel.showInputFields ? Color.red : Color.blue)
                            .cornerRadius(8)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showDeleteAllAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
            }
            .alert(ButtonsStrings.removeItemAlertTitle.localized, isPresented: $viewModel.showDeleteAlert) {
                Button(ButtonsStrings.cancel.localized, role: .cancel) {
                    viewModel.itemToDelete = nil
                }
                Button(ButtonsStrings.remove.localized, role: .destructive) {
                    viewModel.deleteItem()
                }
            } message: {
                Text(ButtonsStrings.removeItemAlertMessage.localized)
            }
            .alert(ButtonsStrings.removeAllItemsAlertTitle.localized, isPresented: $viewModel.showDeleteAllAlert) {
                Button(ButtonsStrings.cancel.localized, role: .cancel) {}
                Button(ButtonsStrings.remove.localized, role: .destructive) {
                    withAnimation {
                        viewModel.items.removeAll()
                        viewModel.saveItems()
                    }
                }
            } message: {
                Text(ButtonsStrings.removeAllItemsAlertMessage.localized)
            }
        }
        .padding(.top, 20)
    }
    
    private var mainContentView: some View {
        VStack {
            if viewModel.showInputFields {
                InputFieldsView(viewModel: viewModel)
                    .padding(.top, 20)
            }
            listView
            TotalView(viewModel: viewModel)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(Sections.allCases, id: \.self) { section in
                sectionView(for: section)
            }
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: viewModel.items)
    }
    
    private func sectionView(for section: Sections) -> some View {
        Section {
            if !viewModel.hiddenSections.contains(section) {
                ForEach(viewModel.items
                    .filter { $0.section == section }
                    .sorted(by: viewModel.sortItems), id: \.id) { item in
                        itemRow(for: item)
                    }
            }
        } header: {
            SectionView(
                section: section,
                isHidden: viewModel.hiddenSections.contains(section),
                onToggle: { viewModel.toggleSectionVisibility(section) }
            ).padding(.horizontal, 16)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    private func itemRow(for item: Item) -> some View {
        ItemRowView(
            viewModel: viewModel,
            item: item,
            onTogglePurchased: { viewModel.togglePurchasedStatus(for: item)
            },
            onEdit: { viewModel.editItem(item) },
            onDelete: { viewModel.removeItem(item) }
        )
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}
