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
        self.book = book

        let rowViewModels = book.sessions
            .map { (session: Session) in
                SessionRowViewModel(session: session)
            }

        sessionsReversedRowViewModels = rowViewModels.reversed()

        sessionsPublisher.store(in: &cancellables)
    }

    var sessionsPublisher: AnyCancellable {
        book.publisher(for: \.sessions)
            .dropFirst()
            .sink { [weak self] sessions in
                guard let self = self else { return }
                // insert last session at the beginning of revesed array
                let last = SessionRowViewModel(session: sessions.last!)
                self.sessionsReversedRowViewModels.insert(last, at: 0)
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
