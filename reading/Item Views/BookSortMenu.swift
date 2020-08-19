//
//  BookSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-16.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookSortMenu: View {
    @Binding var sortDescriptor: NSSortDescriptor

    enum Sort: String, CaseIterable {
        case recent, title, author
    }

    var selectedDescriptor: NSSortDescriptor {
        switch sort {
        case .recent:
            return Book.sortByCreationDate
        case .author:
            return Book.sortByAuthors
        case .title:
            return Book.sortByTitle
        }
    }

    @State private var isOpen = false
    @State private var sort: Sort = .title

    var buttons: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = []
        for sort in Sort.allCases {
            buttons.append(
                .default(
                    Text(sort.rawValue.capitalized),
                    action: {
                        self.sort = sort
                        self.sortDescriptor = self.selectedDescriptor
                })
            )
        }
        buttons.append(.cancel())
        return buttons

    }

    var body: some View {
        Button("Sort by: \(sort.rawValue.capitalized)") {
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

struct BookSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        LivePreviewWrapper()
    }

    // "Live Previews" https://stackoverflow.com/a/59626213
    struct LivePreviewWrapper: View {
        @State private var sortDescriptor: NSSortDescriptor = Book.sortByTitle

        var body: some View {
            BookSortMenu(sortDescriptor: $sortDescriptor)
                .previewLayout(.sizeThatFits)
        }
    }
}
