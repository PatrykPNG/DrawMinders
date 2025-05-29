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
    var uuid: UUID
    var title: String
    var isTemporary: Bool = false // czy to sekcja "Inne"
    var isDefault: Bool = false
    
    @Relationship(deleteRule: .nullify)
    var reminders: [Reminder] = []
    
    var list: MyList?
    
    init(uuid: UUID = UUID(), title: String, isTemporary: Bool = false, isDefault: Bool = false, list: MyList? = nil) {
        self.uuid = uuid
        self.title = title
        self.isTemporary = isTemporary
        self.isDefault = isDefault
        self.list = list
    }
}
