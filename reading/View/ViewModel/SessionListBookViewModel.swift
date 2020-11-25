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
    @Published var sessionsSections: [[SessionRowViewModel]]

    private var newSessionPublisher: AnyPublisher<Session?, Never>
    private var newSessionSubscriber: AnyCancellable?

    init(sessions: [Session], sessionsPublisher: AnyPublisher<[Session], Never>) {
        // eagerly map existing sessions
        let reversedSessions = sessions.reversed()

        var sectionsOfSessions = [[Session]]()

        reversedSessions
            .forEach { (session) in
                if session.reverse_showDayLabel {
                    sectionsOfSessions.append([session])
                } else {
                    sectionsOfSessions[sectionsOfSessions.count - 1].append(session)
                }
            }


        sessionsSections = sectionsOfSessions.map({ (section) in
            section.map { (session) in
                SessionRowViewModel(
                    createdAt: session.createdAt,
                    progressPage: session.progressPage,
                    raw_progressPercent: session.raw_progressPercent,
                    reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())
            }
        })


        sessionsReversedRowViewModels = reversedSessions
            .map({ session in
                SessionRowViewModel(
                    createdAt: session.createdAt,
                    progressPage: session.progressPage,
                    raw_progressPercent: session.raw_progressPercent,
                    reverse_showDayLabelPublisher: session.publisher(for: \.reverse_showDayLabel).eraseToAnyPublisher())
            })

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
