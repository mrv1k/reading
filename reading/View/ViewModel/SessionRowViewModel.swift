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

    // var progressStylePublisher: Published<SessionProgressStyle>.Publisher
    @Published var progressStyle = SessionProgressStyle.page // FIXME:

    init(session: Session, progressStylePublisher: Published<SessionProgressStyle>.Publisher) {
        self.session = session
        // self.progressStylePublisher = progressStylePublisher
        progressStylePublisher.assign(to: &$progressStyle)

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
