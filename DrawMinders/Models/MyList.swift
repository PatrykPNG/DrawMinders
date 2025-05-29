//
//  List.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import Foundation
import SwiftData

@Model
class MyList {
    var uuid: UUID
    var name: String
    var hexColor: String
    var symbol: String
    var isPinned: Bool
    
    @Relationship(deleteRule: .cascade)
    var reminders: [Reminder] = []
    
    @Relationship(deleteRule: .cascade)
    var sections: [ReminderSection] = []
    
    
    init(uuid: UUID = UUID(), name: String, hexColor: String, symbol: String, isPinned: Bool = false) {
        self.uuid = uuid
        self.name = name
        self.hexColor = hexColor
        self.symbol = symbol
        self.isPinned = isPinned
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



