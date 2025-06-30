//
//  SectionHeightmanager.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 26/06/2025.
//

import SwiftUI

class SectionHeightManager: ObservableObject {
    @Published var sectionHeights: [UUID: CGFloat] = [:]
    
    func updateHeight(for sectionId: UUID, height: CGFloat) {
        sectionHeights[sectionId] = height
    }
    
    func removeHeight(for sectionId: UUID) {
        sectionHeights.removeValue(forKey: sectionId)
    }
    
    var totalHeight: CGFloat {
        sectionHeights.values.reduce(0, +)
    }
}
