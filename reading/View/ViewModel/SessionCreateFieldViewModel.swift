//
//  SessionCreateFieldViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

// FIXME: decide what to do with this file
//import CoreData
//
//class SessionCreateFieldViewModel: ViewModel {
//    private var book: Book
//
//    @Published var pageEndInput = ""
//    @Published var pageEndPlaceholder = ""
//
//    init(book: Book) {
//        self.book = book
//        setPlaceholder(page: book.completionPage)
//    }
//
//    func save(context: NSManagedObjectContext) {
//        let session = Session(context: context)
//        session.book = book
//        session.pageEnd = Int16(pageEndInput)!
//        try! context.saveOnChanges(session: session)
//        setPlaceholder(page: pageEndInput)
//        pageEndInput = ""
//    }
//
//    func setPlaceholder<T>(page: T) {
//        pageEndPlaceholder = "Currently on page \(page)"
//    }
//}

