//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import Combine

class SessionRowViewModel: ObservableObject, Identifiable {
    private var session: Session

    // FIXME: these must not have default values, they are always ignored
    @Published var progressStyle = SessionStyleProgress.page
    var timeStyle = SessionStyleTime.time

    var bag = Set<AnyCancellable>()

    init(session: Session,
         progressStylePublisher: Published<SessionStyleProgress>.Publisher,
         timeStylePublisher: Published<SessionStyleTime>.Publisher) {
        self.session = session

        progressStylePublisher.assign(to: &$progressStyle)
        timeStylePublisher
            .assign(to: \.timeStyle, on: self)
            .store(in: &bag)
    }

    var createdAt: Date { session.createdAt }
    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }
    var weekDay: String { Helpers.dateFormatters.day.string(from: session.createdAt) }
    var monthDay: String { Helpers.dateFormatters.month.string(from: session.createdAt) }

    var progress: String {
        progressStyle == .page ? progressPage : progressPercent
    }
    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Helpers.percentCalculator.rounded(session.raw_progressPercent))%"
    }
}
