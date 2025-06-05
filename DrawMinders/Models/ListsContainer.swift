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
    var isEditing = false
    
    var pinnedFilters: [PinnedFilter] {
        _pinnedFilters.sorted { $0.sortOrder < $1.sortOrder }
    }
    
    private var _pinnedFilters = [
        PinnedFilter(type: .today, sortOrder: 0, isVisible: true),
        PinnedFilter(type: .all, sortOrder: 1, isVisible: true),
        PinnedFilter(type: .planned, sortOrder: 2, isVisible: true),
        PinnedFilter(type: .flagged, sortOrder: 3, isVisible: true),
        PinnedFilter(type: .completed, sortOrder: 4, isVisible: true)
    ]
    
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
        
        updateSortOrder(for: pinnedLists)
        updateSortOrder(for: unpinnedLists)
    }
    
    func togglePin(for list: MyList) {
        list.isPinned.toggle()
        list.sortOrder = list.isPinned ? pinnedLists.count : unpinnedLists.count
        refresh(with: allLists)
    }
    
    func toggleEditing() {
        isEditing.toggle()
    }
    
    func updateSortOrder(for lists: [MyList]) {
        for (index, list) in lists.enumerated() {
            list.sortOrder = index
        }
    }
    
    private func updateFilterSortOrder() {
        for (index, filter) in _pinnedFilters.enumerated() {
            filter.sortOrder = index
        }
    }
    
    func moveFilters(from source: IndexSet, to destination: Int) {
        _pinnedFilters.move(fromOffsets: source, toOffset: destination)
        updateFilterSortOrder()
    }
    
    func movePinnedLists(from source: IndexSet, to destination: Int) {
        var currentPinned = pinnedLists
        currentPinned.move(fromOffsets: source, toOffset: destination)
        updateSortOrder(for: currentPinned)
    }
    
    func moveUnpinnedLists(from source: IndexSet, to destination: Int) {
        var currentUnpinned = unpinnedLists
        currentUnpinned.move(fromOffsets: source, toOffset: destination)
        updateSortOrder(for: currentUnpinned)
    }
    
    func moveInSection(from source: IndexSet, to destination: Int) {
        var current = unpinnedLists
        current.move(fromOffsets: source, toOffset: destination)
        updateSortOrder(for: current)
    }
    
    func deleteList(_ list: MyList) {
        allLists.removeAll { $0.id == list.id }
    }
}
