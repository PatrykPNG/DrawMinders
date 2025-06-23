//
//  Reminder.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 01/04/2025.
//

import SwiftUI
import SwiftData
import PencilKit
import UniformTypeIdentifiers

@Model
final class Reminder {
    var uuid: UUID
    var title: String = ""
    var isCompleted: Bool
    var notes: String?
    var reminderDate: Date?
    var reminderTime: Date?
    var isFlagged: Bool
    var isEmpty: Bool = false
   
    var list: MyList?
  
    var section: ReminderSection?
    @Attribute var reminderOrder: Int
    
//    var drawingData: Data? //Data z rysunku
//    var handwrittenText: String?
//    var drawingPreview: Data? //podglad rysunku
//    pamietaj zeby dodac te rzeczy do inita
    
    //jak odnowa bede robic init to daj isCompleted: bool = false. Kiedy init zrobi reminder bedzie ustawione na false, gdyz nie jest jeszcze wykonane
    init(uuid: UUID = UUID(), title: String = "", isCompleted: Bool = false, notes: String? = nil, reminderDate: Date? = nil, reminderTime: Date? = nil, isFlagged: Bool = false, isEmpty: Bool = false, list: MyList? = nil, section: ReminderSection? = nil, reminderOrder: Int = 0) {
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
        self.reminderOrder = reminderOrder
    }
}

extension UTType {
    static let reminder = UTType("com.patrykostrowski.reminder")!
}

extension Reminder {
    var itemProvider: NSItemProvider {
        let provider = NSItemProvider()
        provider.registerDataRepresentation(
            forTypeIdentifier: UTType.reminder.identifier,
            visibility: .all
        ) { completion in
            // Przekazujemy tylko UUID (lub inne potrzebne dane)
            let data = self.uuid.uuidString.data(using: .utf8)
            completion(data, nil)
            return nil
        }
        return provider
    }
}
