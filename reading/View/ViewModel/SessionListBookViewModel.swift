//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

class SessionListBookViewModel: ViewModel, AppSettingsObserver {
//    The element type of a dictionary: a tuple containing an individual key-value pair.
//    typealias Dictionary<Key, Value>.Element = (key: Key, value: Value)

//    @Published var sections = [Dictionary<String, [SessionRowViewModel]>.Element]()
    @Published var sections = [Dictionary<String, [SessionRowViewModel]>.Element]()

    private var newSessionPublisher: AnyPublisher<Session, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        let sectionsDictionary = organizeInDictionaryByDates(sessions: sessions)

        sections = sectionsDictionary
            .sorted(by: settings.sessionsIsSortingByNewest ? sortByNewest : sortByOldest)
            .map { (section: (key: String, sessions: [Session])) in
                // "Closure tuple parameter does not support destructuring"
                let sessions = section.sessions
                    .map { (session: Session) -> SessionRowViewModel in
                        SessionRowViewModel(
                            createdAt: session.createdAt,
                            progressPage: session.progressPage,
                            raw_progressPercent: session.raw_progressPercent)
                    }
                return (section.key, sessions)
            }

        settings.$sessionsIsSortingByNewest
            .dropFirst()
            .sink { isSortingByNewest in print(isSortingByNewest) }
            .store(in: &cancellables)

        let newSessionPublisher = sessionsPublisher
            .dropFirst()
            .compactMap { $0.last }
            .eraseToAnyPublisher()

        self.newSessionPublisher = newSessionPublisher
    }
}

extension SessionListBookViewModel {
    private func makeDateKey(from date: Date) -> String {
        let isToday = Calendar.current.isDateInToday(date)
        return isToday ? "Today" : Helpers.dateFormatters.date.string(from: date)
    }

    private func organizeInDictionaryByDates(sessions: [Session]) -> [String: [Session]] {
        sessions.reduce(into: [:]) { (result: inout [String: [Session]], session: Session) in
            let dateKey = makeDateKey(from: session.createdAt)

            // if key is empty, initialize it to session array
            guard result[dateKey] != nil else { return result[dateKey] = [session] }

            var section = result[dateKey]!
            settings.sessionsIsSortingByNewest ? section.insert(session, at: 0) : section.append(session)
            result[dateKey]! = section
        }
    }
}

extension SessionListBookViewModel {
    typealias SectionTuple = Dictionary<String, [Session]>.Element

    private func sortByNewest(a: SectionTuple, b: SectionTuple) -> Bool {
        a.value.first!.createdAt > b.value.first!.createdAt
    }

    private func sortByOldest(a: SectionTuple, b: SectionTuple) -> Bool {
        a.value.first!.createdAt < b.value.first!.createdAt
    }
}
