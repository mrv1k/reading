//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View, ViewModelObserver {
    @ObservedObject var viewModel: SessionListBookViewModel

    var body: some View {
        ForEach(viewModel.sessionsReversedRowViewModels) { sessionRowViewModel in
            SessionRow(viewModel: sessionRowViewModel)
        }
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let viewModel = SessionListBookViewModel(book: book)

        return Group {
            SessionListBook(viewModel: viewModel)
                .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(viewModel: viewModel)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
