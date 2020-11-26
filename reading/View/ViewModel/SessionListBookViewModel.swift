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
    typealias SectionElement = Dictionary<String, [SessionRowViewModel]>.Element
    @Published var sections = [SectionElement]()

    private var newSessionPublisher: AnyPublisher<Session, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        sections =
            organizeInDictionary(sessions, by: settings.sessionsIsSortingByNewest)
                .mapValues(transformToViewModels(sessions:))
                .sorted(by: settings.sessionsIsSortingByNewest ? sortByNewest : sortByOldest)

        settings.$sessionsIsSortingByNewest
            .dropFirst()
            .sink { [weak self] isSortingByNewest in
                guard let self = self else { return }
                self.sections.sort(by: isSortingByNewest ? self.sortByNewest : self.sortByOldest)
            }
            .store(in: &cancellables)

        // TODO: restore UI update when new session is added

        let newSessionPublisher = sessionsPublisher
            .dropFirst()
            .compactMap { $0.last }
            .eraseToAnyPublisher()

        self.newSessionPublisher = newSessionPublisher
    }
}

private extension SessionListBookViewModel {
    func makeDateKey(from date: Date) -> String {
        let isToday = Calendar.current.isDateInToday(date)
        return isToday ? "Today" : Helpers.dateFormatters.date.string(from: date)
    }

    func organizeInDictionary(
        _ sessions: [Session],
        by isSortingByNewest: Bool
    ) -> [String: [Session]] {
        sessions.reduce(into: [:]) { (result: inout [String: [Session]], session: Session) in
            let dateKey = makeDateKey(from: session.createdAt)

            // if key is empty, initialize it to session array
            guard result[dateKey] != nil else { return result[dateKey] = [session] }

            var section = result[dateKey]!
            isSortingByNewest ? section.insert(session, at: 0) : section.append(session)
            result[dateKey]! = section
        }
    }

    func transformToViewModels(sessions: [Session]) -> [SessionRowViewModel] {
        sessions.map { (session: Session) -> SessionRowViewModel in
            SessionRowViewModel(
                createdAt: session.createdAt,
                progressPage: session.progressPage,
                raw_progressPercent: session.raw_progressPercent
            )
        }
    }
}

private extension SessionListBookViewModel {
    func sortByNewest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.createdAt > b.value.first!.createdAt
    }

    func sortByOldest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.createdAt < b.value.first!.createdAt
    }
}
