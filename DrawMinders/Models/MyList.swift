//
//  List.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import Foundation
import SwiftData
//Pozmieniac relacje zeby usuwalo sie tak jak nalezy

@Model
class MyList {
    var uuid: UUID
    var name: String
    var hexColor: String
    var symbol: String
    var isPinned: Bool
    @Attribute var sortOrder: Int
    
    @Relationship(deleteRule: .cascade, inverse: \Reminder.list)
    var reminders: [Reminder] = []
    
    @Relationship(deleteRule: .cascade, inverse: \ReminderSection.list)
    var sections: [ReminderSection] = []
    
    
    init(uuid: UUID = UUID(), name: String, hexColor: String, symbol: String, isPinned: Bool = false, sortOrder: Int = 0) {
        self.uuid = uuid
        self.name = name
        self.hexColor = hexColor
        self.symbol = symbol
        self.isPinned = isPinned
        self.sortOrder = sortOrder
    }
    
    func cleanupEmptySections() {
        let sectionsToRemove = sections.filter { section in
            !section.isDefault &&
            section.reminders.isEmpty &&
            (section.title.isEmpty || section.isTemporary)
        }
        
        sections.removeAll { sectionsToRemove.contains($0) }
    }
}



