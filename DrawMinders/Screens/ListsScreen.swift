//
//  listsScreen.swift
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

struct ListsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var allLists: [MyList]
    
    @State private var activeSheet: ListSheet? = nil
    @State private var navigationPath = NavigationPath()
    @State private var selectedTile: ListTileModel?
    @State private var container = ListsContainer()
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack {
                    if container.isEditing {
                        EditListView(
                            activeSheet: $activeSheet,
                            container: container
                        )
                        .transition(.opacity)
                    } else {
                        TilesGrid(
                            activeSheet: $activeSheet,
                            selectedTile: $selectedTile,
                            container: container
                        )
                        .transition(.scale)
                        
                        MyListsSectionView(
                            activeSheet: $activeSheet,
                            navigationPath: $navigationPath,
                            container: container
                        )
                        .transition(.scale)
                    }
                }
            }
            .onAppear {
                container.refresh(with: allLists)
            }
            .onChange(of: allLists) {
                container.refresh(with: allLists)
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(item: $selectedTile) { tile in
                switch tile.type {
                case .list(let list):
                    ListDetailScreen(myList: list)
                case .filter(let filterType):
                    switch filterType {
                    case .all:
                        AllRemindersView()
                    case .completed:
                        CompletedRemindersView()
                    case .flagged:
                        FlaggedRemindersView()
                    case .planned:
                        PlannedRemindersView()
                    case .today:
                        TodayRemindersView()
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
                            .onDisappear {
                                container.refresh(with: allLists)
                                
                            }
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            container.toggleEditing()
                        }
                    } label: {
                        Text(container.isEditing ? "Done" : "Edit")
                            .fontWeight(.medium)
                    }
                }
            }
        }
        
    }
}

#Preview { @MainActor in
    NavigationStack {
        ListsScreen()
    }
    .modelContainer(mockPreviewConteiner)
}




