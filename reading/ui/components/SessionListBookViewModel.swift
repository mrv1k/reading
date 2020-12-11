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
    @Published var sessions: [Session]

    @Published var isSortingByNewest = false /// `self.`
    typealias SectionElement = Dictionary<String, [SessionRowViewModel]>.Element
    @Published var sections = [SectionElement]()

    private var cancellables = Set<AnyCancellable>()

    init(sessions: [Session]) {
        self.sessions = sessions

        AppSettingsEditorViewModel.singleton.$sessionsIsSortingByNewest.assign(to: &$isSortingByNewest)

        sections =
            organizeInDictionary(sessions, by: isSortingByNewest)
                .mapValues(transformToViewModels(sessions:))
                .sorted(by: isSortingByNewest ? sortByNewest : sortByOldest)

        $isSortingByNewest
            .dropFirst()
            .sink { [weak self] isSortingByNewest in
                guard let self = self else { return }
                self.sections.sort(by: isSortingByNewest ? self.sortByNewest : self.sortByOldest)
            }
            .store(in: &cancellables)

        // FIXME: properly handle it now that you're in control of types
//        $sessions.sink(receiveValue:)
//        $addSessionActive
//            .dropFirst()
//            .sink { active in
//                if active {
//                    let session = Session(context: self.viewContext)
//                    session.book = book
//                    let sessionRow = SessionRowViewModel(session: session, isNewSession: true)
//                    self.newSessionRow = sessionRow
//
//                    if self.isSortingByNewest {
//                        var section = self.sections.first!.value
//                        section.insert(sessionRow, at: 0)
//                        self.sections[0].value = section
//                    } else {
//                        var section = self.sections.last!.value
//                        section.append(sessionRow)
//                        self.sections[self.sections.count - 1].value = section
//                    }
//                }
//            }
//            .store(in: &cancellables)
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
            SessionRowViewModel(session: session)
        }
    }
}

private extension SessionListBookViewModel {
    func sortByNewest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.session.createdAt > b.value.first!.session.createdAt
    }

    func sortByOldest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.session.createdAt < b.value.first!.session.createdAt
    }
}
