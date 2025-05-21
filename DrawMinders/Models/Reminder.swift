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
    var title: String
    var isCompleted: Bool = false
    var drawingData: Data? //Data z rysunku
    var handwrittenText: String?
    var drawingPreview: Data? //podglad rysunku
//    var canvasWidth: Double = 300
    var canvasHeight: Double = 100.0 {
        didSet {
            print("Zmiana canvasHeight: \(oldValue) na \(canvasHeight)")
        }
    }
    var list: MyList?
    
    init(title: String, list: MyList? = nil) {
        self.title = title
        self.list = list
    }
    
    static let sampleData = [
        Reminder(title: "test1"),
        Reminder(title: "test2"),
        Reminder(title: "test3"),
        Reminder(title: "test4"),
    ]
}
