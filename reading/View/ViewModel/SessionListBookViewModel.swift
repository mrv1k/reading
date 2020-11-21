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

    // TODO: move out
    @Published var pageEndField = ""

    @Published var sessionsReversedRowViewModels = [SessionRowViewModel]()
    var cancellables = Set<AnyCancellable>()

    init(book: Book) {
        print("SessionListBook VM")
        self.book = book

        sessionsReversedRowViewModels = book.sessionsReversed
            .map { (session: Session) in
                SessionRowViewModel(session: session)
            }

        reverseSessionLastPublisher.store(in: &cancellables)
    }

    var reverseSessionLastPublisher: AnyCancellable {
        book.publisher(for: \.sessionsReversed)
            .combineLatest($sessionsReversedRowViewModels)
            .dropFirst()
            .sink { sessionsReversed, sessionsReversedRowViewModels in
                /** array.first == arayReversed.last
                    array.last == arayReversed.first
                 */
                let last = sessionsReversed.first!
                let t = SessionRowViewModel(session: last)
                self.sessionsReversedRowViewModels.insert(t, at: 0)
            }
//        book.publisher(for: \.sessionsReversed)
//            .sink { [weak self] (sessionsReversed: [Session]) in
//                guard let self = self else { return }
//                print(sessionsReversed.count)
//
//                self.sessionsReversedRowViewModels.append(SessionRowViewModel(session: sessionsReversed.last!))
//            }
    }

    func save(context: NSManagedObjectContext) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndField)!
        try! context.saveOnChanges(session: session)
        pageEndField = ""
    }
}
