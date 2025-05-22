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
    
    var body: some View {
        HStack {
            Image(systemName: myList.symbol)
                .font(.title)
                .foregroundStyle(Color(hex: myList.hexColor))
            
            Text(myList.name)
        }
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
