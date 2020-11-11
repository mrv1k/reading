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

    init(book: Book) {
        let viewModel = SessionListBookViewModel(book: book)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            HStack {
                TextField("I'm on page", text: $viewModel.pageEndField)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button {
                    viewModel.save(context: viewContext)
                } label: {
                    Image(systemName: "plus.circle.fill").imageScale(.large)
                }
            }

            ForEach(viewModel.sessionRowViewModels) { sessionRowViewModel in
                SessionRow(viewModel: sessionRowViewModel)
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
