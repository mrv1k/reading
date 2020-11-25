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
        ForEach(viewModel.arrayOfSectionDictionaries, id: \.key) { (dictionaryTuple: (Dictionary<String, [SessionRowViewModel]>.Element)) in
            Section(header: Text(dictionaryTuple.key)) {
                ForEach(dictionaryTuple.value) { sessionVM in
                    SessionRow(viewModel: sessionVM)
                }
            }
        }
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let sessionsPublisher = book.publisher(for: \.sessions).eraseToAnyPublisher()
        let viewModel = SessionListBookViewModel(sessions: book.sessions, sessionsPublisher: sessionsPublisher)

        return Group {
            List {
                SessionListBook(viewModel: viewModel)
            }
            .listStyle(InsetGroupedListStyle())

            NavigationView {
                List {
                    SessionListBook(viewModel: viewModel)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
