import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            mainContentView
                .opacity(viewModel.isLoading ? 0 : 1)
            
            if viewModel.isLoading {
                LoadingView()
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
    
    private var mainContentView: some View {
        VStack {
            HeaderView(viewModel: viewModel)
            InputFieldsView(viewModel: viewModel)
            listView
                .padding(.top, 20)
            TotalView(viewModel: viewModel)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(Sections.allCases, id: \.self) { section in
                sectionView(for: section)
            }
        }
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
            SectionHeaderView(
                section: section,
                isHidden: viewModel.hiddenSections.contains(section),
                onToggle: { viewModel.toggleSectionVisibility(section) }
            )
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
    }
}
