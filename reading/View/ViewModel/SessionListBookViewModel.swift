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
    @Published var pageEndField = ""
    let book: Book

    init(book: Book) {
        self.book = book
    }

    var sessionRowViewModels: [SessionRowViewModel] {
        book.sessionsReversed.map {
            SessionRowViewModel(session: $0)
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
