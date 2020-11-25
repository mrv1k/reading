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

    @Published var sections: [Dictionary<String, [SessionRowViewModel]>.Element]

    private var newSessionPublisher: AnyPublisher<Session?, Never>
    private var newSessionSubscriber: AnyCancellable?

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        let reversedSessions = sessions.reversed()

        var dateSections: [String: [Session]] = [:]
        let sortNewestFirst = true
//        var sortComparator: (Date, Date) -> Bool = sortNewestFirst ? (>) : (<)

        sessions
            .forEach { session in
                let isToday = Calendar.current.isDateInToday(session.createdAt)
                let dateKey = isToday ? "Today" : Helpers.dateFormatters.date.string(from: session.createdAt)

                // if key is not initialized, initialize it to session array
                guard dateSections[dateKey] != nil else {
                    return dateSections[dateKey] = [session]
                }
                if sortNewestFirst {
                    dateSections[dateKey]!.insert(session, at: 0)
                } else {
                    dateSections[dateKey]!.append(session)
                }
            }

        // TODO: refactor to work in both directions
        let sortedSections = dateSections.sorted(by: { (a, b) -> Bool in
            a.value.first!.createdAt > b.value.first!.createdAt
        })

        sections = sortedSections.map { (section: (key: String, value: [Session])) in
            let key = section.key
            let value = section.value
                .map { (session: Session) -> SessionRowViewModel in
                    SessionRowViewModel(
                        createdAt: session.createdAt,
                        progressPage: session.progressPage,
                        raw_progressPercent: session.raw_progressPercent,
                        reverse_showDayLabelPublisher: AnyPublisher(session.publisher(for: \.reverse_showDayLabel)))
                }
            return (key, value)
        }

        sessionsReversedRowViewModels = reversedSessions
            .map { session in
                SessionRowViewModel(
                    createdAt: session.createdAt,
                    progressPage: session.progressPage,
                    raw_progressPercent: session.raw_progressPercent,
                    reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())
            }

        newSessionPublisher = sessionsPublisher
            .dropFirst()
            .map { $0.last }
            .eraseToAnyPublisher()

        newSessionSubscriber = newSessionPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (session: Session?) in
                // session is nil Book was deleted
                guard let session = session else { return }
                // insert last session at the beginning of revesed array
                let rowViewModel = SessionRowViewModel(
                    createdAt: session.createdAt,
                    progressPage: session.progressPage,
                    raw_progressPercent: session.raw_progressPercent,
                    reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())

                self?.sessionsReversedRowViewModels.insert(rowViewModel, at: 0)
            }
    }
}
