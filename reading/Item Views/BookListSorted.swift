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

    let modalView: Bool
    let onTap: (_ book: Book) -> Void

    let fetchRequest: FetchRequest<Book>
    var books: FetchedResults<Book> {
        fetchRequest.wrappedValue
    }

    init(sortDescriptor: NSSortDescriptor,
         modalView: Bool = false,
         onTap: @escaping (_ book: Book) -> Void = {_ in }
    ) {
        fetchRequest = FetchRequest<Book>(
            entity: Book.entity(),
            sortDescriptors: [sortDescriptor]
        )
        self.modalView = modalView
        self.onTap = onTap
    }

    var body: some View {
        if modalView {
            ForEach(books) { book in
                BookRow(book: book)
                    .onTapGesture {
                        onTap(book)
                    }
            }
        } else {
            ForEach(books) { book in
                NavigationLink(
                    destination: BookDetail(book: book)
                ) {
                    BookRow(book: book)
                }
            }
            .onDelete(perform: deleteBook)
        }
    }

    func deleteBook(indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                viewContext.delete(self.books[index])
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
