//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Combine

class SessionListBookViewModel: ObservableObject {
    private let book: Book

    @Published var pageEndField = ""
    // TODO: should be persistent 
    @Published var progressStyle = SessionProgressStyle.page

    init(book: Book) {
        self.book = book
    }

    var sessionRowViewModels: [SessionRowViewModel] {
        book.sessionsReversed.map { session in
            SessionRowViewModel(
                session: session,
                progressStylePublisher: $progressStyle)
        }
    }

    func save(context: NSManagedObjectContext) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndField)!
        try! context.saveOnChanges(session: session)
        pageEndField = ""
    }
}

enum SessionProgressStyle {
    case page
    case percent
}
