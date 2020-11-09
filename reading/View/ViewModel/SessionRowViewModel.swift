//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class SessionRowViewModel: ObservableObject, Identifiable {
    private var session: Session

    init(session: Session) {
        self.session = session
    }

    var weekDay: String {
        Helpers.dateFormatters.day.string(from: session.createdAt)
    }

    var monthDay: String {
        Helpers.dateFormatters.month.string(from: session.createdAt)
    }

    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }

    // var sessionProgress: String { TODO }

    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Helpers.percentCalculator.rounded(session.raw_progressPercent))%"
    }
}
