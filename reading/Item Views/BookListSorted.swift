//
//  BookListSorted.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-21.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListSorted: View {
    @Environment(\.managedObjectContext) private var viewContext

    var fetchRequest: FetchRequest<Book>
    var books: FetchedResults<Book> {
        fetchRequest.wrappedValue
    }

    init(sortDescriptor: NSSortDescriptor) {
        fetchRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [sortDescriptor]
        )
    }

    var body: some View {
        ForEach(books) { book in
            NavigationLink(
                destination: BookDetail(book: book)
            ) {
                BookRow(book: book)
            }
        }
        .onDelete(perform: { indexSet in
            for index in indexSet {
                self.viewContext.delete(self.books[index])
            }
        })
    }
}
