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
final class Reminder: Codable, Transferable {
    var uuid: UUID
    var title: String = ""
    var isCompleted: Bool
    var notes: String?
    var reminderDate: Date?
    var reminderTime: Date?
    var isFlagged: Bool
    var isEmpty: Bool = false
    var list: MyList?
    @Relationship
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
    
    enum CodingKeys: String, CodingKey {
        case uuid, title, isCompleted, notes, reminderDate, reminderTime, isFlagged, isEmpty, reminderOrder
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        title = try container.decode(String.self, forKey: .title)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        notes = try container.decodeIfPresent(String.self, forKey: .notes)
        reminderDate = try container.decodeIfPresent(Date.self, forKey: .reminderDate)
        reminderTime = try container.decodeIfPresent(Date.self, forKey: .reminderTime)
        isFlagged = try container.decode(Bool.self, forKey: .isFlagged)
        isEmpty = try container.decode(Bool.self, forKey: .isEmpty)
        reminderOrder = try container.decode(Int.self, forKey: .reminderOrder)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(notes, forKey: .notes)
        try container.encodeIfPresent(reminderDate, forKey: .reminderDate)
        try container.encodeIfPresent(reminderTime, forKey: .reminderTime)
        try container.encode(isFlagged, forKey: .isFlagged)
        try container.encode(isEmpty, forKey: .isEmpty)
        try container.encode(reminderOrder, forKey: .reminderOrder)
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .reminder)
    }
}

extension UTType {
    static let reminder = UTType("com.patrykostrowski.reminder")!
}

