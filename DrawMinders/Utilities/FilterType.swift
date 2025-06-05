//
//  FilterType.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 03/06/2025.
//

import SwiftUI

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
