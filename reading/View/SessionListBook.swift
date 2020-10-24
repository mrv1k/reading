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
    @StateObject var viewModel: SessionListBookViewModel

    @State private var pageEndField = "101"

    init(book: Book) {
        // self.book = book
        _viewModel = StateObject(wrappedValue: SessionListBookViewModel(book: book))
    }

    var body: some View {
        LazyVStack {
            HStack {
                TextField("I'm on page", text: $pageEndField)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    let session = Session(context: viewContext)
                    session.book = viewModel.book
                    session.pageEnd = Int16(pageEndField)!
                    session.computeMissingAttributes()
                    try! viewContext.save()
                    print("woosh: added session")
                    // TODO: find a cleaner solution
                    viewModel.sessionRowViewModelList.insert(
                        SessionRowViewModel(session: session),
                        at: 0)
                    pageEndField = ""
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
            }

            ForEach(viewModel.sessionRowViewModelList) { sessionViewModel in
                SessionRow(
                    viewModel: sessionViewModel,
                    listViewModel: viewModel)
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
