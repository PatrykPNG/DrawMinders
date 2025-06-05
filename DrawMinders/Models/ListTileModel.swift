//
//  ReminderTileModel.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 24/05/2025.
//

import Foundation
import SwiftUI

enum TileType {
    case filter(FilterType)
    case list(MyList)
}

struct ListTileModel: Identifiable, Hashable {
    let id: String
    let symbol: String
    let symbolColor: Color
    let title: String
    let type: TileType
    let count: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

