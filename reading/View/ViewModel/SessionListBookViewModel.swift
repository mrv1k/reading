//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import CoreData

class SessionListBookViewModel: ViewModel {
    private let book: Book
    @Published var sessionRowViewModels = [SessionRowViewModel]()

//    @Published var temp = [Session]()
    @Published var sessionSet: NSOrderedSet?
    let setSnapshot: NSOrderedSet?
    let arraySnapshot: [Session]

    @Published var pageEndField = ""

    var wawawewa = Set<AnyCancellable>()

    init(book: Book) {
        print("SessionListBook VM")
        self.book = book

        let p = book.publisher(for: \.sessionsSet)

        setSnapshot = book.sessionsSet
        arraySnapshot = book.sessions


        p
            .map({ (updatedSet: NSOrderedSet?) in
                print(updatedSet?.count, self.sessionSet?.count)
                print(self.setSnapshot?.count, self.arraySnapshot.count)
                return updatedSet
            })
            .assign(to: &$sessionSet)
    }

    // FIXME: currently fully recomputes when new session is added,
    // and when progress style or time style updates
//    var sessionRowViewModels: [SessionRowViewModel] {
//        print()
//        return book.sessionsReversed.map { (session: Session) in
//            print("fired")
//            return SessionRowViewModel(session: session)
//        }
//    }

    func save(context: NSManagedObjectContext) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndField)!
        try! context.saveOnChanges(session: session)
        pageEndField = ""
    }
}
