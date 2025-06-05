//
//  PinnedFilter.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 04/06/2025.
//

import SwiftUI

@Observable
class PinnedFilter: Identifiable {
    let id = UUID()
    let type: FilterType
    var sortOrder: Int
    var isVisible: Bool
    
    init(type: FilterType, sortOrder: Int, isVisible: Bool = true) {
        self.type = type
        self.sortOrder = sortOrder
        self.isVisible = isVisible
    }
}
