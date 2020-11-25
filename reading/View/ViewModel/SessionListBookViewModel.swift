//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

//        var header: Text {
//            Text(viewModel.date).font(.footnote).foregroundColor(.gray)
//        }
//        var date: String
//        date = Calendar.current.isDateInToday(createdAt) ? "Today" :
//            Helpers.dateFormatters.date.string(from: createdAt)

class SessionListBookViewModel: ViewModel {
    @Published var sessionsReversedRowViewModels: [SessionRowViewModel]
//    @Published var sessionsSections: [[SessionRowViewModel]]
//    @Published var arrayOfSectionDictionaries: [String: [Session]]
    @Published var arrayOfSectionDictionaries: [Dictionary<String, [SessionRowViewModel]>.Element]
//    @Published var arrayOfSectionDictionaries: Array<(key: String, value: Array<Session>)> = []

    private var newSessionPublisher: AnyPublisher<Session?, Never>
    private var newSessionSubscriber: AnyCancellable?

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        let reversedSessions = sessions.reversed()

        var sections: [String: [Session]] = [:]

        // note: not reversed as it's sorted after assembling into dictionary
        sessions
            .forEach { session in
                let date = Calendar.current.isDateInToday(session.createdAt) ? "Today" :
                    Helpers.dateFormatters.date.string(from: session.createdAt)
                print("foreach")

                if session.reverse_showDayLabel {
                    sections[date] = [session]
                } else {
                    if sections[date] != nil {
                        sections[date]!.append(session)
                    } else {
                        sections[date] = [session]
                    }
                }
            }

        let sortedSections = sections.sorted(by: { (a, b) -> Bool in
            a.value.first!.createdAt > b.value.first!.createdAt
        })

        arrayOfSectionDictionaries = sortedSections.map { (section: (key: String, value: [Session])) in
            print("section")
            let key = section.key
            let value = section.value
//                .map(<#T##transform: (Session) throws -> T##(Session) throws -> T#>)
                .map { (session: Session) -> SessionRowViewModel in
                    print("sessionRowVM")
                    return SessionRowViewModel(
                        createdAt: session.createdAt,
                        progressPage: session.progressPage,
                        raw_progressPercent: session.raw_progressPercent,
                        reverse_showDayLabelPublisher: AnyPublisher(session.publisher(for: \.reverse_showDayLabel)))
                }
            print(section.value.count, value.count)

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
