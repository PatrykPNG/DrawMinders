//
//  DropTargetOverlay.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 25/06/2025.
//

import SwiftUI

struct DropTargetOverlay: View {
    let isTargeted: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.clear)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isTargeted ? Color.blue.opacity(0.15) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isTargeted ? Color.blue.opacity(0.6) : Color.clear,
                                lineWidth: 2
                            )
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}
