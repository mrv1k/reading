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
                if bookSort == sort {
                    Label(sort.computedStruct.labelName, systemImage: sort.computedStruct.labelImage).tag(sort)
                } else {
                    Text(sort.computedStruct.labelName).tag(sort)
                }
            }
        }
    }
}

struct BookListSortPicker_Previews: PreviewProvider {
    static var previews: some View {
        Menu {
            BookListSortPicker(bookSort: .constant(BookSort.init(rawValue: "author")!))
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
