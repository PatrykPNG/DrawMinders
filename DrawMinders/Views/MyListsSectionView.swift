//
//  MyListsSectionView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 25/05/2025.
//

import SwiftUI
import SwiftData

struct MyListsSectionView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(filter: #Predicate<MyList> { !$0.isPinned }) private var myLists: [MyList]
    @Binding var activeSheet: ListSheet?
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My lists")
                    .font(.title2)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            
            VStack(spacing: 1) {
                ForEach(myLists) { myList in
                    NavigationLink {
                        ListDetailScreen(myList: myList)
                    } label: {
                        ListRowView(myList: myList)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button {
                            myList.isPinned.toggle()
                        } label: {
                            Label(myList.isPinned ? "Unpin" : "Pin", systemImage: myList.isPinned ? "pin.slash" : "pin")
                        }
                        
                        Button {
                            activeSheet = .edit(myList)
                        } label: {
                            Label("Edit list", systemImage: "info.circle")
                        }
                        
                        Button {
                            //share
                        } label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            modelContext.delete(myList)
                        } label: {
                            Label("Delete list", systemImage: "trash")
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(myList)
                        } label: {
                            Label("Delete List", systemImage: "trash")
                        }
                        
                        Button() {
                            activeSheet = .edit(myList)
                        } label: {
                            Label("Edit list", systemImage: "info.circle")
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct MyListsSectionViewContainer: View {

    @State var activeSheet: ListSheet? = nil
    @State var navigationPath = NavigationPath()

    var body: some View {
        MyListsSectionView(activeSheet: $activeSheet, navigationPath: $navigationPath)
    }
}

#Preview { @MainActor in
    NavigationStack {
        MyListsSectionViewContainer()
    }
    .modelContainer(mockPreviewConteiner)
}
