//
//  ListRowView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 21/05/2025.
//

import SwiftUI
import SwiftData

struct ListRowView: View {
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
            
            Spacer()
            
            Text("\(totalRemindersCount)")
                .font(.body)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        // jesli bedziemy w trybie edycji wylacz contexxtmenu i swipeactions
        .contextMenu {
            Button {
                onPinToggle()
            } label: {
                Label(myList.isPinned ? "Unpin" : "Pin", systemImage: myList.isPinned ? "pin.slash" : "pin")
            }

            Button {
                onEdit()
            } label: {
                Label("Edit list", systemImage: "info.circle")
            }

            Button {
                //share
            } label: {
                Label("Share", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete list", systemImage: "trash")
            }
        }
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete List", systemImage: "trash")
            }

            Button() {
                onEdit()
            } label: {
                Label("Edit list", systemImage: "info.circle")
            }
        }
        
    }
    
    private var totalRemindersCount: Int {
        myList.reminders.count + myList.sections.flatMap { $0.reminders }.count
    }
}


struct ListRowViewContainer: View {

    @Query private var myList: [MyList]

    var body: some View {
        ListRowView(
            myList: myList[0],
            onDelete: { print("Delete tapped") },
            onEdit: { print("Edit tapped") },
            onPinToggle: { print("Pin toggled") }
        )
    }
}

#Preview { @MainActor in
    ListRowViewContainer()
        .modelContainer(mockPreviewConteiner)
}
