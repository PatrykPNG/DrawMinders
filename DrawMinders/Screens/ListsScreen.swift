//
//  listsView.swift
//  Reminders_Pencil
//
//  Created by Patryk Ostrowski on 18/05/2025.
//

import SwiftUI

struct listsView: View {
    let lists = ["domowe", "cwiczenia", "zakupy"]
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        List {
            Text("My Lists")
                .font(.largeTitle)
                .bold()
            
            ForEach(lists, id: \.self) { list in
                HStack {
                    Image(systemName: "list.bullet.circle.fill")
                    
                    Text(list)
                }
            }
            
            //ten buutton poirtem chyba w toolbar
            Button {
                isPresented = true
            } label: {
                Text("add list")
                    .foregroundStyle(.blue)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .popover(isPresented: $isPresented) {
            NavigationStack {
                AddListScreen()
            }
        }
    }
}

#Preview {
    NavigationStack {
        listsView()
    }
}
