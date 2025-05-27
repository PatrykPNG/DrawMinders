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

struct ReminderTileModel: Identifiable, Hashable {
    let id = UUID()
    let symbol: String
    let symbolColor: Color
    let title: String
    let type: TileType
    let count: Int
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

enum FilterType {
    case today
    case all
    case planned
    case flagged
    case completed
    
    var title: String {
        switch self {
        case .today: return "Today"
        case .all: return "All"
        case .planned: return "Planned"
        case .flagged: return "Flagged"
        case .completed: return "Completed"
        }
    }
    
    var symbol: String {
        switch self {
        case .today: return "calendar.circle.fill"
        case .all: return "tray.circle.fill"
        case .planned: return "calendar.circle.fill"
        case .flagged: return "flag.circle.fill"
        case .completed: return "checkmark.circle.fill"
        }
    }
    
    var symbolColor: Color {
        switch self {
        case .today: return .blue
        case .all: return .gray
        case .planned: return .red
        case .flagged: return .orange
        case .completed: return .gray
        }
    }
}
