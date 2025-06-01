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

struct listsScreen: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var activeSheet: ListSheet? = nil
    @State private var navigationPath = NavigationPath()
    @State private var selectedTile: ReminderTileModel?
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack {
                    TilesGrid(selectedTile: $selectedTile)
            
                    MyListsSectionView(
                        activeSheet: $activeSheet,
                        navigationPath: $navigationPath
                    )
                }
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Text("Clean DataBase")
                    }
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




