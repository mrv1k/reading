//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import Combine

class SessionRowViewModel: ObservableObject, Identifiable, AppSettingsConsumer {
    private var session: Session

    init(session: Session) {
        self.session = session
    }

    var createdAt: Date { session.createdAt }
    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }
    var weekDay: String { Helpers.dateFormatters.day.string(from: session.createdAt) }
    var monthDay: String { Helpers.dateFormatters.month.string(from: session.createdAt) }

    var progress: String {
        settings.progressPercentage ? progressPercent : progressPage
    }
    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}
