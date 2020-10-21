//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionListBook: View {
    @StateObject var viewModel: SessionListBookViewModel

    init(sessions: [Session]) {
        _viewModel = StateObject(wrappedValue: SessionListBookViewModel(session: sessions))
    }

    var body: some View {
        LazyVStack {
            ForEach(viewModel.sessionsRowViewModels) { rowViewModel in
                SessionRow(
                    viewModel: rowViewModel,
                    listViewModel: viewModel)
            }
        }
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)

        return Group {
            SessionListBook(sessions: book.sessions)
                .previewLayout(.sizeThatFits)

            NavigationView {
                SessionListBook(sessions: book.sessions)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
