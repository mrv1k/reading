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

        if pageEnd == 31 {
            session.createdAt = Date() - 60 * 60 * 24 * 2
        }
        if pageEnd == 60 {
            session.createdAt = Date() - 60 * 60 * 24
        }

        session.computeMissingAttributes()
        try! context.save()
    }

    func insertMany(book: Book) {
        let sessionEndArray = [31, 60, 83] // , 101

        sessionEndArray.forEach { pageEnd in
            insert(book: book, pageEnd: pageEnd)
        }
    }
}
