//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

class SessionListBookViewModel: ViewModel {
    @Published var sessionsReversedRowViewModels: [SessionRowViewModel]
    private var newSessionsPublisher: AnyPublisher<Session?, Never>
    private var newSessionSubscriber: AnyCancellable?

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        sessionsReversedRowViewModels = sessions
            .map { SessionRowViewModel(session: $0) }
            .reversed()

        newSessionsPublisher = sessionsPublisher
            .dropFirst()
            .map { $0.last }
            .eraseToAnyPublisher()

        newSessionSubscriber = newSessionsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (session: Session?) in
                // session is nil Book was deleted
                guard let session = session else { return }
                // insert last session at the beginning of revesed array
                let rowViewModel = SessionRowViewModel(session: session)
                self?.sessionsReversedRowViewModels.insert(rowViewModel, at: 0)
            }
    }
}
