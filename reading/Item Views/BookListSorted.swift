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
        .onDelete(perform: deleteBook)
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
