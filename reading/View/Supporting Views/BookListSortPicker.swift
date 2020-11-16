//
//  BookListSortPicker.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

enum BookSortMenuOption: String, CaseIterable, Identifiable {
    case title = "Title"
    case author = "Author"
    case createdAt = "Date"

    var id: String { rawValue }
}

struct BookListSortPicker: View {
    @EnvironmentObject private var bookStorage: BookStorage

    var body: some View {
        Picker("Sorting options", selection: $bookStorage.sortSelection) {
            ForEach(BookSortMenuOption.allCases) { sort in
                if bookStorage.sortSelection == sort {
                    Label(sort.rawValue, systemImage: bookStorage.sortDirectionImage).tag(sort)
                } else {
                    Text(sort.rawValue).tag(sort)
                }
            }
        }
    }
}

struct BookListSortPicker_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext

        return Menu {
            BookListSortPicker()
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
                .padding()
        }
        .environmentObject(BookStorage(viewContext: viewContext))
        .previewLayout(.sizeThatFits)
    }
}
