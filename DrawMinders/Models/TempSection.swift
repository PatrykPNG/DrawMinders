//
//  TempSection.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 10/06/2025.
//

import SwiftUI

class TempSection: Identifiable, ObservableObject {
    let id = UUID()
    var title: String = ""
    
    init() {}
    
    static func == (lhs: TempSection, rhs: TempSection) -> Bool {
        lhs.id == rhs.id
    }
}
