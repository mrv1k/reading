//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class SessionListBookViewModel: ViewModel {
    private let book: Book

    @Published var sessionsReversedRowViewModels = [SessionRowViewModel]()

    var cancellables = Set<AnyCancellable>()

    init(book: Book) {
        print("List init")
        self.book = book

        let rowViewModels = book.sessions
            .map { (session: Session) in
                SessionRowViewModel(session: session)
            }
        sessionsReversedRowViewModels = rowViewModels.reversed()

        sessionsPublisher.store(in: &cancellables)
    }

    deinit {
        print("List deinit")
    }

    var sessionsPublisher: AnyCancellable {
        book.publisher(for: \.sessions)
            .dropFirst()
            .sink { [weak self] sessions in
                print("sink")
                guard let self = self,
                      let newSession = sessions.last else { return }
                print("self and newSess present")
                // insert last session at the beginning of revesed array
                let rowViewModel = SessionRowViewModel(session: newSession)
                self.sessionsReversedRowViewModels.insert(rowViewModel, at: 0)
            }
    }
}
