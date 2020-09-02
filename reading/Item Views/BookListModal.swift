//
//  BookListModal.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListModal: View {
    @ObservedObject var bookStorage: BookStorage
    var books: [Book] { bookStorage.books }

    var body: some View {
        List {
            ForEach(books) { book in
                BookRow(book: book)
                    .onTapGesture {
                        print(book)
                    }
            }
        }
    }
}

struct BookListModal_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)
        let bookStorage = BookStorage(viewContext: viewContext)

        return BookListModal(bookStorage: bookStorage)
    }
}
