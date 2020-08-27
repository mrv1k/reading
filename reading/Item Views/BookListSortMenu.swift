//
//  BookListSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortMenu: View {
    @Binding var sortDescriptor: NSSortDescriptor

    enum Sort: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case recent, title, author
    }

    var selectedDescriptor: NSSortDescriptor {
        switch currentSort {
        case .recent:
            return Book.sortByCreationDate
        case .author:
            return Book.sortByAuthors
        case .title:
            return Book.sortByTitle
        }
    }

    @State private var currentSort: Sort
    @State private var isOpen = false

    init(initialSortDescriptor: Binding<NSSortDescriptor>) {
        _sortDescriptor = initialSortDescriptor

        var initialSort: Sort
        switch _sortDescriptor.wrappedValue {
        case Book.sortByCreationDate:
            initialSort = .recent
        case Book.sortByAuthors:
            initialSort = .author
        case Book.sortByTitle:
            initialSort = .title
        default:
            initialSort = .author
            #if DEBUG
            fatalError("Failed to initialize `initialSort` from `initialSortDescriptor`")
            #endif
        }

        _currentSort = State(initialValue: initialSort)
    }

    var body: some View {
        ForEach(Sort.allCases, content: { (selectedSort) in
            Button(action: {
                guard self.currentSort != selectedSort else {
                    return
                }
                self.currentSort = selectedSort
                self.sortDescriptor = self.selectedDescriptor
            }, label: {
                Text(selectedSort.rawValue.capitalized)
            })
        })
    }
}
