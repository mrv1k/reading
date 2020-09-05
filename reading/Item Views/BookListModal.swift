//
//  BookListModal.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookListModal: View {
    @EnvironmentObject private var bookStorage: BookStorage
    var books: [Book] { bookStorage.books }

    @Binding var bookSelection: Book?
    @State private var isOpen: Bool = false

    var title: String {
        bookSelection == nil ? "Select a book" : "Change selection"
    }

    var body: some View {
        Button(title) {
            self.isOpen = true
        }.sheet(isPresented: $isOpen, content: {
            List {
                ForEach(books) { book in
                    Button(action: {
                        bookSelection = book
                        self.isOpen = false
                    }, label: {
                        BookRow(book: book)
                    })
                    .accentColor(.primary)
                    .listRowBackground(bookSelection == book ? Color.green : nil)
                }
            }
        })
    }
}

struct BookListModal_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)

        return Group {
            BookListModal(bookSelection: .constant(nil))
        }
        .environmentObject(BookStorage(viewContext: viewContext))
        .previewLayout(.sizeThatFits)
    }
}
