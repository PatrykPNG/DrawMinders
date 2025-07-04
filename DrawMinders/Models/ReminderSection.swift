//
//  ReminderSection.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 27/05/2025.
//

import Foundation
import SwiftData

@Model
class ReminderSection {
    @Attribute(.unique) var uuid: UUID
    var title: String
    var sortOrder: Int
    @Relationship(deleteRule: .cascade, inverse: \Reminder.section)
    var reminders: [Reminder] = []
    
    var isExpanded: Bool = true
    var list: MyList?
    
    init(uuid: UUID = UUID(), title: String, sortOrder: Int = 0, isExpanded: Bool = true, list: MyList? = nil) {
        self.uuid = uuid
        self.title = title
        self.sortOrder = sortOrder
        self.isExpanded = isExpanded
        self.list = list
    }

}

