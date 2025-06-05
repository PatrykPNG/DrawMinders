//
//  TileFactory.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 02/06/2025.
//

import SwiftUI

struct TileFactory {
    static func createTile(for filter: FilterType, reminders: [Reminder]) -> ListTileModel {
        ListTileModel(
            id: filter.title,
            symbol: filter.symbol,
            symbolColor: filter.symbolColor,
            title: filter.title,
            type: .filter(filter),
            count: countForFilter(filter, reminders: reminders)
        )
    }
    
    static func createTile(for list: MyList) -> ListTileModel {
        ListTileModel(
            id: list.uuid.uuidString,
            symbol: list.symbol,
            symbolColor: Color(hex: list.hexColor),
            title: list.name,
            type: .list(list),
            count: calculateListCount(list)
        )
    }
    
    private static func countForFilter(_ filter: FilterType, reminders: [Reminder]) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else { return 0 }
        
        switch filter {
        case .today:
            return reminders.filter {
                guard let date = $0.reminderDate else { return false }
                return date >= today && date < tomorrow && !$0.isCompleted
            }.count
        case .all: return reminders.count
        case .planned: return reminders.filter { $0.reminderDate != nil && !$0.isCompleted }.count
        case .flagged: return reminders.filter { $0.isFlagged && !$0.isCompleted }.count
        case .completed: return reminders.filter { $0.isCompleted }.count
        }
    }
    
    private static func calculateListCount(_ list: MyList) -> Int {
        list.reminders.count + list.sections.flatMap { $0.reminders }.count
    }
}

