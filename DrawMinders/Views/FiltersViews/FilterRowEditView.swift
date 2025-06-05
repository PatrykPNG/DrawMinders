//
//  FilterRowView.swift
//  DrawMinders
//
//  Created by Patryk Ostrowski on 03/06/2025.
//

import SwiftUI

struct FilterRowEditView: View {
    @Bindable var filter: PinnedFilter
    
    var body: some View {
        HStack(spacing: 12) {
            Button {
                filter.isVisible.toggle()
            } label: {
                Image(systemName: filter.isVisible ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(filter.isVisible ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(.plain)
            
            Image(systemName: filter.type.symbol)
                .font(.largeTitle)
                .foregroundStyle(.white, filter.type.symbolColor)
            
            Text(filter.type.title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    FilterRowEditView(filter: PinnedFilter(type: .all, sortOrder: 1, isVisible: true))
}
