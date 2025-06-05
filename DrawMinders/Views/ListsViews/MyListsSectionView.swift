//
//  MyListsSectionView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 25/05/2025.
//

import SwiftUI
import SwiftData

struct MyListsSectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var activeSheet: ListSheet?
    @Binding var navigationPath: NavigationPath
    
    let container: ListsContainer
    
    var body: some View {
        // przyblizona wartosc wiersza DO POPRAWY
        let rowHeight: CGFloat = 95
        let listHeight = CGFloat(container.unpinnedLists.count) * rowHeight
        
        List {
            Section {
                ForEach(container.unpinnedLists) { myList in
                    NavigationLink {
                        ListDetailScreen(myList: myList)
                    } label: {
                        ListRowView(
                            myList: myList,
                            onDelete: { deleteList(myList) },
                            onEdit: { activeSheet = .edit(myList) },
                            onPinToggle: { myList.isPinned.toggle() }
                        )
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                }
                // Przy nowej wersji ios Moze przestac dzialac
                .onMove { source, destination in
                    container.moveInSection(from: source, to: destination)
                }
                
            } header: {
                Text("My lists")
                    .font(.headline)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
            }
        }
        //ToDo: Sprawdzic ile wysokosci ma moj row i zmienic w rowHeight
        .frame(height: listHeight)
        .scrollDisabled(true)
    }
    
    private func deleteList(_ list: MyList) {
        container.deleteList(list)
        modelContext.delete(list)
    }
}

struct MyListsSectionViewContainer: View {

    @State var activeSheet: ListSheet? = nil
    @State var navigationPath = NavigationPath()
    let container = ListsContainer()

    var body: some View {
        MyListsSectionView(activeSheet: $activeSheet, navigationPath: $navigationPath, container: container)
            .onAppear {
                container.refresh(with: SampleDataLists.myLists)
            }
            .onChange(of: SampleDataLists.myLists) {
                container.refresh(with: SampleDataLists.myLists)
            }
            .environment(container)
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsSectionViewContainer()
    }
    .modelContainer(mockPreviewConteiner)
}



