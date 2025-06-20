//
//  TempSectionRow.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 10/06/2025.
//

import SwiftUI

struct TempSectionRow: View {
    @ObservedObject var section: TempSection
    var onCommit: () -> Void
    var onCancel: () -> Void
    
    @FocusState private var isFocused: Bool
    @State private var initialText: String = ""

    
    var body: some View {
        HStack {
            TextField("Nazwa sekcji", text: $section.title, onCommit: onCommit)
                .font(.title3)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .focused($isFocused)
                .onAppear {
                    initialText = section.title
                    isFocused = true
                }
                .onDisappear {
                    if section.title.isEmpty {
                        onCancel()
                    }
                }
        }
    }
}


