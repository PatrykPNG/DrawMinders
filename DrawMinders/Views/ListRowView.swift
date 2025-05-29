//
//  ListRowView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 21/05/2025.
//

import SwiftUI
import SwiftData

struct ListRowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Bindable var myList: MyList
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: myList.symbol)
                .font(.largeTitle)
                .foregroundStyle(.white, Color(hex: myList.hexColor))
                .frame(width: 24, height: 24)

            
            Text(myList.name)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text("\(totalRemindersCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(colorScheme == .dark ? Color(.systemGray6) : Color.white)
        .contentShape(Rectangle())
        
    }
    
    private var totalRemindersCount: Int {
        myList.reminders.count + myList.sections.flatMap { $0.reminders }.count
    }
}


struct ListRowViewContainer: View {

    @Query private var myList: [MyList]

    var body: some View {
        ListRowView(myList: myList[0])
    }
}

#Preview { @MainActor in
    ListRowViewContainer()
        .modelContainer(mockPreviewConteiner)
}
