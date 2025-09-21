import SwiftUI
import Combine

struct ContentView<
    Store: ItemsStoreProtocol,
    FormVM: ItemFormViewModelProtocol,
    SectionsVM: SectionsVisibilityViewModelProtocol,
    AlertsVM: AlertsViewModelProtocol
>: View {

    @StateObject private var itemsStore: Store
    @StateObject private var formVM: FormVM
    @StateObject private var sectionsVM: SectionsVM
    @StateObject private var alertsVM: AlertsVM
    
    // Estado derivado dos publishers do store
    @State private var items: [Item] = []
    @State private var isLoading: Bool = true
    
    init(itemsStore: Store, formVM: FormVM, sectionsVM: SectionsVM, alertsVM: AlertsVM) {
        _itemsStore = StateObject(wrappedValue: itemsStore)
        _formVM = StateObject(wrappedValue: formVM)
        _sectionsVM = StateObject(wrappedValue: sectionsVM)
        _alertsVM = StateObject(wrappedValue: alertsVM)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                mainContentView
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    LoadingView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            itemsStore.loadInitialData()
        }
        .onReceive(itemsStore.itemsPublisher) { newItems in
            withAnimation(.easeInOut) {
                self.items = newItems
            }
        }
        .onReceive(itemsStore.isLoadingPublisher) { loading in
            withAnimation(.easeInOut) {
                self.isLoading = loading
            }
        }
    }
    
    private var mainContentView: some View {
        VStack {
            HeaderView(formViewModel: formVM, alertsViewModel: alertsVM)
            if formVM.showInputFields {
                InputFieldsView(formVM: formVM)
                    .padding(.top, 20)
            }
            listView
            TotalView(itemsStore: itemsStore)
        }
    }
    
    private var listView: some View {
        let sections = sectionsWithItems()
        
        return List {
            // Use a própria seção como identidade, não o índice
            ForEach(Array(sections.enumerated()), id: \.element) { (idx, section) in
                sectionView(for: section, colorIndex: idx, total: sections.count)
            }
        }
        .listStyle(.plain)
        .animation(.easeInOut, value: items)
    }
    
    private func sectionView(for section: Sections, colorIndex: Int, total: Int) -> some View {
        Section {
            if !sectionsVM.hiddenSections.contains(section) {
                ForEach(items
                    .filter { $0.section == section }
                    .sorted(by: itemsStore.sortItems), id: \.id) { item in
                        itemRow(for: item)
                    }
            }
        } header: {
            SectionView(
                section: section,
                color: SectionColors.colorForVisibleSection(at: colorIndex, total: total),
                sectionsVM: sectionsVM
            )
            .padding(.horizontal, 16)
        }
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.automatic)
    }
    
    private func itemRow(for item: Item) -> some View {
        ItemRowView(
            itemsStore: itemsStore,
            formVM: formVM,
            item: item
        )
        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
    
    private func sectionsWithItems() -> [Sections] {
        let sectionsWithContent = Sections.allCases.filter { section in
            items.contains { $0.section == section }
        }
        return sectionsWithContent.sorted {
            $0.localized.localizedCompare($1.localized) == .orderedAscending
        }
    }
}
