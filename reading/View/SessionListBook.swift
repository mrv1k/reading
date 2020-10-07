//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View {
    var book: Book

    var body: some View {
        List {
            Text("by " + book.authors)
            Text(String(book.pageCount) + " pages")
            Spacer()

            ForEach(0..<20) { _ in
                SessionRow()
            }
        }
        .navigationTitle(book.title)
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        let seeder = BookSeeder(context: viewContext)

        return SessionListBook(book: seeder.insert(bookWith: .minimum))
    }
}
