//
//  BookListSortPicker.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortPicker: View {
    @Binding var bookSort: BookSort

    var body: some View {
        Picker("Sorting options", selection: $bookSort) {
            ForEach(BookSort.allCases) { sort in
                Text(sort.rawValue.capitalized).tag(sort)
            }
        }
    }
}

struct BookListSortPicker_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookListSortPicker(bookSort: .constant(BookSort.init(rawValue: "title")!))
            BookListSortPicker(bookSort: .constant(BookSort.init(rawValue: "author")!))
            BookListSortPicker(bookSort: .constant(BookSort.init(rawValue: "date")!))
        }
        .previewLayout(.sizeThatFits)
    }
}