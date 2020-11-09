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

    func saveSession(context: NSManagedObjectContext, book: Book) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndField)!
        session.computeMissingAttributes()
        try! context.saveOnChanges()
        pageEndField = ""
    }
}
