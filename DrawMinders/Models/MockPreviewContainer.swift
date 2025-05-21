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
    let container = try! ModelContainer(for: MyList.self, configurations: config)
    
    for myList in SampleDataLists.myLists {
        container.mainContext.insert(myList)
    }
    
    return container
}()

struct SampleDataLists {
    
    static var myLists: [MyList] {
        return [
            MyList(name: "Test1", HexColor: "#FF0000", symbol: "envelope.circle.fill"),
            MyList(name: "Test2", HexColor: "#FFA500", symbol: "scissors.circle.fill"),
            MyList(name: "Test3", HexColor: "#0000FF", symbol: "cart.circle.fill"),
            MyList(name: "Test4", HexColor: "#008000", symbol: "shoe.circle.fill")
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
