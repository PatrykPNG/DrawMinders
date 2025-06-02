//
//  SampleData.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 16/05/2025.
//

import SwiftUI
import SwiftData

@MainActor
var mockPreviewConteiner: ModelContainer = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MyList.self, Reminder.self, ReminderSection.self, configurations: config)
    
    for myList in SampleDataLists.myLists {
        container.mainContext.insert(myList)
        
        // Przykład listy bez sekcji
        if myList.name == "Test1" {
            for reminder in SampleDataLists.reminders {
                reminder.list = myList
                myList.reminders.append(reminder)
            }
        }
        
        // Przykład listy z sekcjami
        if myList.name == "Test2" {
            let section1 = ReminderSection(title: "Section1", list: myList)
            let section2 = ReminderSection(title: "Section2", isTemporary: true, list: myList)
            
            section1.reminders.append(Reminder(title: "Reminder1S", section: section1))
            section2.reminders.append(Reminder(title: "Reminder2S", section: section2))
            section2.reminders.append(Reminder(title: "", isEmpty: true, section: section2))
            
            myList.sections.append(section1)
            myList.sections.append(section2)
        }
    }
    
    return container
}()

struct SampleDataLists {
    
    static var myLists: [MyList] {
        return [
            MyList(name: "Test1", hexColor: "#42c5f5", symbol: "envelope.circle.fill", isPinned: true),
            MyList(name: "Test2", hexColor: "#4bf542", symbol: "scissors.circle.fill"),
            MyList(name: "Test3", hexColor: "#daf542", symbol: "cart.circle.fill")
//            MyList(name: "Test4", hexColor: "#f56042", symbol: "shoe.circle.fill")
        ]
    }
    
    static var reminders: [Reminder] {
        return [
            Reminder(title: "Reminder1", isCompleted: true, notes: "Note for test1", reminderDate: Date(), reminderTime: Date()),
            Reminder(title: "Reminder2", notes: "Note for test2", reminderDate: Date()),
            Reminder(title: "Reminder3"),
        ]
    }
}



//static let sampleDataList = [
//    MyList(name: "Test1", HexColor: "#FF0000", symbol: "envelope.circle.fill"),
//    MyList(name: "Test2", HexColor: "#FFA500", symbol: "scissors.circle.fill"),
//    MyList(name: "Test3", HexColor: "#0000FF", symbol: "cart.circle.fill"),
//    MyList(name: "Test4", HexColor: "#008000", symbol: "shoe.circle.fill")
//]
//}
