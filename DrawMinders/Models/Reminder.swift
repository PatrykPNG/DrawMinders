//
//  Reminder.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 01/04/2025.
//

import Foundation
import SwiftData
import PencilKit

@Model
class Reminder {
    var uuid: UUID
    var title: String
    var isCompleted: Bool
    var notes: String?
    var reminderDate: Date?
    var reminderTime: Date?
    var isFlagged: Bool
    var isEmpty: Bool = false
    var list: MyList?
    var section: ReminderSection? //jezeli nil , to przypomnienie jest bez sekcji
//    var drawingData: Data? //Data z rysunku
//    var handwrittenText: String?
//    var drawingPreview: Data? //podglad rysunku
//    pamietaj zeby dodac te rzeczy do inita

    
    
    //jak odnowa bede robic init to daj isCompleted: bool = false. Kiedy init zrobi reminder bedzie ustawione na false, gdyz nie jest jeszcze wykonane
    init(uuid: UUID = UUID(), title: String, isCompleted: Bool = false, notes: String? = nil, reminderDate: Date? = nil, reminderTime: Date? = nil, isFlagged: Bool = false, isEmpty: Bool = false, list: MyList? = nil, section: ReminderSection? = nil) {
        self.uuid = uuid
        self.title = title
        self.isCompleted = isCompleted
        self.notes = notes
        self.reminderDate = reminderDate
        self.reminderTime = reminderTime
        self.isFlagged = isFlagged
        self.isEmpty = isEmpty
        self.list = list
        self.section = section
    }
    
//    static let sampleDataReminder = [
//        Reminder(title: "test1"),
//        Reminder(title: "test2"),
//        Reminder(title: "test3"),
//        Reminder(title: "test4"),
//    ]
}
