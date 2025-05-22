//
//  listsView.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI
import SwiftData

enum ListSheet: Identifiable {
    case new
    case edit(MyList)
    
    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let list):
            return "edit_\(list.persistentModelID)"
        }
    }
}

struct listsScreen: View {
    
    @Query private var myLists: [MyList]
    
    @State private var isPresented: Bool = false
    @State private var activeSheet: ListSheet? = nil
    
    var body: some View {
        
        List {
            TilesGrid()
            .listRowInsets(EdgeInsets())
            
            Section(header: Text("My lists").font(.headline).fontWeight(.bold)) {
                ForEach(myLists) { myList in
                    NavigationLink {
                        ListDetailScreen(myList: myList)
                    } label: {
                        ListRowView(myList: myList)
                    }
                    .contextMenu {
                        Button {
                            //pin
                        } label: {
                            Label("Pin", systemImage: "pin")
                        }
                        
                        Button {
                            activeSheet = .edit(myList)
                        } label: {
                            Label("Info", systemImage: "info.circle")
                        }
                        
                        Button {
                            //share
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            //Delete
                        } label: {
                            Label("Delete list", systemImage: "trash")
                        }
                    }
//                    .swipeActions {
//                        Button(role: .destructive) {
//                            deleteReminder(myList)
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                    }
                }
            }
        }
        .navigationTitle("My Lists")
        .sheet(item: $activeSheet) { sheet in
            NavigationStack {
                switch sheet {
                case .new:
                    AddListScreen()
                case .edit(let list):
                    AddListScreen(existingList: list)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    //add reminder view
                } label: {
                    Image(systemName: "plus.circle.fill")
                    Text("Reminder")
                        .foregroundStyle(.blue)
                        .fontWeight(.bold)
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                Button {
                    activeSheet = .new
                } label: {
                    Text("add list")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        listsScreen()
    }
    .modelContainer(mockPreviewConteiner)
}




