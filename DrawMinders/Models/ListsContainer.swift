//
//  ListsContainer.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 01/06/2025.
//

import SwiftUI
import SwiftData

@Observable
class ListsContainer {
    private var allLists: [MyList] = []
    var filterOrder: [FilterType] = [.today, .all, .planned, .flagged, .completed]
    
    var isEditing = false
    
    var pinnedLists: [MyList] {
        allLists
            .filter { $0.isPinned }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    var unpinnedLists: [MyList] {
        allLists
            .filter { !$0.isPinned }
            .sorted { $0.sortOrder < $1.sortOrder }
    }
    
    func refresh(with lists: [MyList]) {
        allLists = lists
    }
    
    func togglePin(for list: MyList) {
        list.isPinned.toggle()
        list.sortOrder = Int(Date().timeIntervalSince1970)
    }
    
    func toggleEditing() {
        isEditing.toggle()
    }
    
    func movePinnedLists(from source: IndexSet, to destination: Int) {
        var pinned = pinnedLists
        pinned.move(fromOffsets: source, toOffset: destination)
        updateSortOrders(for: pinned)
    }
    
    func moveUnpinnedLists(from source: IndexSet, to destination: Int) {
        var unpinned = unpinnedLists
        unpinned.move(fromOffsets: source, toOffset: destination)
        updateSortOrders(for: unpinned)
    }
    
    func updateSortOrders(for lists: [MyList]) {
        for (index, list) in lists.enumerated() {
            list.sortOrder = index
        }
    }
}
