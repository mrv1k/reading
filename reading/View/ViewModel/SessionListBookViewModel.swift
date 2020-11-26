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
    @Published var sections = [Dictionary<String, [SessionRowViewModel]>.Element]()
    // TODO: allow user to control this variable through Settings
    @Published var sortNewestFirst = false

    private var newSessionPublisher: AnyPublisher<Session, Never>?
    private var newSessionSubscriber: AnyCancellable?

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        var dateSections: [String: [Session]] = [:]

        sessions
            .forEach { session in
                let dateKey = makeDateKey(from: session.createdAt)

                // if key is not initialized, initialize it to session array
                guard dateSections[dateKey] != nil else {
                    return dateSections[dateKey] = [session]
                }

                var section = dateSections[dateKey]!
                sortNewestFirst ? section.insert(session, at: 0) : section.append(session)
                dateSections[dateKey]! = section
            }

        sections = dateSections
            .sorted(by: sortNewestFirst ? byNewest : byOldest)
            .map { (section: (key: String, sessions: [Session])) in
                // "Closure tuple parameter does not support destructuring"
                let sessions = section.sessions
                    .map { (session: Session) -> SessionRowViewModel in
                        SessionRowViewModel(
                            createdAt: session.createdAt,
                            progressPage: session.progressPage,
                            raw_progressPercent: session.raw_progressPercent,
                            reverse_showDayLabelPublisher: AnyPublisher(session.publisher(for: \.reverse_showDayLabel)))
                    }
                return (section.key, sessions)
            }

        let newSessionPublisher = sessionsPublisher
            .dropFirst()
            .compactMap { $0.last }
            .eraseToAnyPublisher()

        // TODO: adopt to work with dictionary
        let newSessionSubscriber = newSessionPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] (session: Session) in
                guard let self = self else { return }
                let rowViewModel = SessionRowViewModel(
                    createdAt: session.createdAt,
                    progressPage: session.progressPage,
                    raw_progressPercent: session.raw_progressPercent,
                    reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())

//                let dateKey = self.makeDateKey(from: session.createdAt)
//                let t = self.sections[dateKey]
//                print(t)
//                self?.sessionsReversedRowViewModels.insert(rowViewModel, at: 0)
            }

        self.newSessionPublisher = newSessionPublisher
        self.newSessionSubscriber = newSessionSubscriber
    }

    func makeDateKey(from date: Date) -> String {
        let isToday = Calendar.current.isDateInToday(date)
        return isToday ? "Today" : Helpers.dateFormatters.date.string(from: date)
    }

    typealias sectionTuple = Dictionary<String, [Session]>.Element
    private func byNewest(a: sectionTuple, b: sectionTuple) -> Bool {
        a.value.first!.createdAt > b.value.first!.createdAt
    }

    private func byOldest(a: sectionTuple, b: sectionTuple) -> Bool {
        a.value.first!.createdAt < b.value.first!.createdAt
    }
}
