//
//  BookListSortMenu.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortMenu: View {
    @Binding var bookSort: BookSort
    @State private var isOpen = false

    var body: some View {
        Picker("Sorting options", selection: $bookSort) {
            ForEach(BookSort.allCases) { sort in
                Text(sort.rawValue.capitalized).tag(sort)
            }
        }
    }
}

struct BookListSortMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListSortMenu(bookSort: .constant(BookSort.init(rawValue: "title")!))
            BookListSortMenu(bookSort: .constant(BookSort.init(rawValue: "author")!))
            BookListSortMenu(bookSort: .constant(BookSort.init(rawValue: "date")!))
        }
        .previewLayout(.sizeThatFits)
    }
}
