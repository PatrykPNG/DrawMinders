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
    
    @Query(filter: #Predicate<MyList> { !$0.isPinned }) private var myLists: [MyList]
    @Binding var activeSheet: ListSheet?
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        // przyblizona wartosc wiersza DO POPRAWY
        let rowHeight: CGFloat = 95
        let listHeight = CGFloat(myLists.count) * rowHeight
        
        List {
            Section {
                ForEach(myLists) { myList in
                    NavigationLink {
                        ListDetailScreen(myList: myList)
                    } label: {
                        ListRowView(
                            myList: myList,
                            onDelete: { modelContext.delete(myList) },
                            onEdit: { activeSheet = .edit(myList) },
                            onPinToggle: { myList.isPinned.toggle() }
                        )
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
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
}

struct MyListsSectionViewContainer: View {

    @State var activeSheet: ListSheet? = nil
    @State var navigationPath = NavigationPath()

    var body: some View {
        MyListsSectionView(activeSheet: $activeSheet, navigationPath: $navigationPath)
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsSectionViewContainer()
    }
    .modelContainer(mockPreviewConteiner)
}


