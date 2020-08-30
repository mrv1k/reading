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

    @State private var isOpen = false
    @State private var selectedSort: Sort

    enum Sort: String, CaseIterable, Identifiable {
        case recent, title, author
        var id: String { self.rawValue }
    }

    var selectedDescriptor: NSSortDescriptor {
        switch selectedSort {
        case .recent:
            return Book.sortByCreationDate
        case .author:
            return Book.sortByAuthors
        case .title:
            return Book.sortByTitle
        }
    }

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
        _selectedSort = State(initialValue: initialSort)
    }

    var body: some View {
        // https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-bindings
        let selection = Binding<Sort> {
            self.selectedSort
        } set: { newSort in
            self.selectedSort = newSort
            self.sortDescriptor = selectedDescriptor
        }

        Picker("Sorting options", selection: selection) {
            ForEach(Sort.allCases) { sort in
                Text(sort.rawValue.capitalized).tag(sort)
            }
        }
    }
}

struct BookListSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewWrapper()
    }

    // "Live Previews" https://stackoverflow.com/a/59626213
    struct LivePreviewWrapper: View {
        @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

        var body: some View {
            BookListSortMenu(initialSortDescriptor: $sortDescriptor)
                .previewLayout(.sizeThatFits)
        }
    }
}
