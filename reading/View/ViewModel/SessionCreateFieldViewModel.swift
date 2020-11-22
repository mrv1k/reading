//
//  SessionCreateFieldViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

class SessionCreateFieldViewModel: ViewModel {
    private var book: Book

    @Published var pageEndInput = ""
    @Published var pageEndPlaceholder = "placeholder"

    init(book: Book) {
        self.book = book
        pageEndPlaceholder = "I'm on page \(book.completionPage)"
    }

    func save(context: NSManagedObjectContext) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndInput)!
        try! context.saveOnChanges(session: session)
        pageEndInput = ""
    }
}
