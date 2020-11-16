//
//  BookListSortPicker.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSortPicker: View {
    @EnvironmentObject private var bookStorage: BookStorage

    var body: some View {
        Picker("Sorting options", selection: $bookStorage.sortSelection) {
            ForEach(BookSortSelection.allCases) { sortSelection in
                if bookStorage.sortSelection == sortSelection {
                    Label(sortSelection.rawValue, systemImage: bookStorage.directionImage).tag(sortSelection)
                } else {
                    Text(sortSelection.rawValue).tag(sortSelection)
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
