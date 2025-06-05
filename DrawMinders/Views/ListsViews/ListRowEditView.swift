//
//  ListRowEditView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 03/06/2025.
//

import SwiftUI
import SwiftData

struct ListRowEditView: View {
    @Bindable var myList: MyList
    var onDelete: (() -> Void)
    var onEdit: (() -> Void)
    var onPinToggle: (() -> Void)
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: myList.symbol)
                .font(.largeTitle)
                .foregroundStyle(.white, Color(hex: myList.hexColor))
            
            Text(myList.name)
                .font(.body)
                .foregroundStyle(.primary)
            
            Button(action: onEdit) {
                Image(systemName: "info.circle")
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
            
            Spacer()

            Button(action: onPinToggle) {
                Image(systemName: myList.isPinned ? "pin.fill" : "pin.slash")
                    .foregroundStyle(.yellow)
            }
            .buttonStyle(.plain)

        }
        .contentShape(Rectangle())
    }

}


struct ListRowEditViewContainer: View {

    @Query private var myList: [MyList]

    var body: some View {
        ListRowEditView(
            myList: myList[0],
            onDelete: { print("Delete tapped") },
            onEdit: { print("Edit tapped") },
            onPinToggle: { print("Pin toggled") }
        )
    }
}

#Preview { @MainActor in
    ListRowEditViewContainer()
        .modelContainer(mockPreviewConteiner)
}
