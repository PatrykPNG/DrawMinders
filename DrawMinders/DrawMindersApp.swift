//
//  DrawMindersApp.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI

@main
struct DrawMindersApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                listsScreen()
            }
            .modelContainer(for: MyList.self)
        }
    }
}
