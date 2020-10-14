//
//  SessionSeeder.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct SessionSeeder {
    static let preview = SessionSeeder(viewContext: PersistenceController.preview.container.viewContext)

    private let context: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        context = viewContext
    }

    func insert(book: Book, pageEnd: Int) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEnd)
        session.autofillProgress()
    }

    func insertMany(book: Book) {
        let sessionEndArray = [31, 60, 83, 101]

        sessionEndArray.forEach { pageEnd in
            insert(book: book, pageEnd: pageEnd)
        }

        book.completionPercent =
            book.sessions.map { $0.progressPercent }
            .reduce(0) { $0 + $1 }
    }
}
