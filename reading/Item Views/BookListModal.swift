//
//  BookListModal.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListModal: View {
    @EnvironmentObject var bookStorage: BookStorage
    var books: [Book] { bookStorage.books }

    @State private var isOpen: Bool = false

    var body: some View {
        Button("Select a book") {
            self.isOpen = true
        }.sheet(isPresented: $isOpen, content: {
            List {
                ForEach(books) { book in
                    BookRow(book: book)
                        .onTapGesture {
                            print(book)
                        }
                }
            }
        })
    }
}

struct BookListModal_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)

        return BookListModal()
            .environmentObject(BookStorage(viewContext: viewContext))
    }
}
