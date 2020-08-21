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

    enum Sort: String, CaseIterable {
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

    var buttons: [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()
        for selectedSort in Sort.allCases {
            buttons.append(
                .default(
                    Text(selectedSort.rawValue.capitalized),
                    action: {
                        guard self.currentSort != selectedSort else {
                            return
                        }
                        self.currentSort = selectedSort
                        self.sortDescriptor = self.selectedDescriptor
                })
            )
        }
        buttons.append(.cancel())
        return buttons
    }

    var body: some View {
        Button("Sort by: \(currentSort.rawValue.capitalized)") {
            self.isOpen = true
        }
        .actionSheet(isPresented: $isOpen) {
            ActionSheet(
                title: Text("Sort by:"),
                buttons: buttons
            )
        }
    }
}

struct BookListSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewWrapper()
    }

    // "Live Previews" https://stackoverflow.com/a/59626213
    struct LivePreviewWrapper: View {
        @State private var sortDescriptor: NSSortDescriptor = Book.sortByTitle

        var body: some View {
            BookListSortMenu(initialSortDescriptor: $sortDescriptor)
                .previewLayout(.sizeThatFits)
        }
    }
}
