//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View, ViewModelObserver {
    @StateObject var viewModel: SessionListBookViewModel

    init(book: Book) {
        print("list view init")
        _viewModel = StateObject(wrappedValue: SessionListBookViewModel(book: book))
    }

    var body: some View {
        VStack {
            ForEach(viewModel.sessionsReversedRowViewModels) { sessionRowViewModel in
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
