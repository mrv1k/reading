//
//  SessionListBook.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-07.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import SwiftUI

struct SessionListBook: View, ViewModelObserver {
    @StateObject var viewModel: SessionListBookViewModel

    init(sessions: [Session]) {
        self._viewModel = StateObject(wrappedValue: SessionListBookViewModel(sessions: sessions))
    }

    var body: some View {
        ForEach(viewModel.sections, id: \.key) { dateHeader, rowViewModels in
            Section(header: Text(dateHeader)) {
                ForEach(rowViewModels) { rowViewModel in
                    SessionRow()
                }
            }
        }
    }
}

struct SessionListBook_Previews: PreviewProvider {
    static var previews: some View {
//        let book = BookSeeder.preview.fetch(bookWith: .sessions)
//        let sessions = book.sessions

        return Group {
            NavigationView {
                List {
//                    SessionListBook(sessions: sessions)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .previewDevice("iPhone SE (2nd generation)")
    }
}
