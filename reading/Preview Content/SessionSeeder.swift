//
//  SessionSeeder.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import CoreData

struct SessionSeeder {
    static let preview = SessionSeeder(viewContext: PersistenceController.preview.container.viewContext)
    static var emptyBoolPublisher = AnyPublisher(Empty<Bool, Never>())

    private let context: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        context = viewContext
    }

    func insert(book: Book, pageEnd: Int) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEnd)

        if pageEnd == 31 {
            session.createdAt = Date() - 60 * 60 * 24 * 2 // 2 days ago
        }
        if pageEnd == 60 {
            session.createdAt = Date() - 60 * 60 * 24 // 1 day ago
        }

        try! context.saveOnChanges(session: session)
    }

    func insertMany(book: Book) {
        let sessionEndArray = [31, 60, 83, 99] 

        sessionEndArray.forEach { pageEnd in
            insert(book: book, pageEnd: pageEnd)
        }
    }
}
