//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View {
    @Environment(\.managedObjectContext) private var viewContext

    var book: Book

    @State private var pageEndField = ""

    var body: some View {
        LazyVStack {
            HStack {
                TextField("I'm on page", text: $pageEndField)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    let session = Session(context: viewContext)
                    session.book = book
                    session.pageEnd = Int16(pageEndField)!
                    session.computeMissingAttributes()
                    try! viewContext.save()
                    print(Date(), "Added session")
                    pageEndField = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }

            ForEach(book.sessionsReversed) { session in
                SessionRow(session: session)
            }
        }
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)

        return Group {
            SessionListBook(book: book)
                .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(book: book)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
