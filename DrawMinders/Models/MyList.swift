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
    var name: String
    
    @Relationship(deleteRule: .cascade)
    var reminders: [Reminder] = []
    
    init(name: String) {
        self.name = name
    }
}
