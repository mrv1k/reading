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
    var settings: AppSettings

    init(session: Session, settings: AppSettings) {
        self.session = session
        self.settings = settings
    }

    var timeStyle: SessionStyleTime {
        settings.timeStyle
    }

    var createdAt: Date { session.createdAt }
    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }
    var weekDay: String { Helpers.dateFormatters.day.string(from: session.createdAt) }
    var monthDay: String { Helpers.dateFormatters.month.string(from: session.createdAt) }

    var progress: String {
        settings.progressStyle == .page ? progressPage : progressPercent
    }
    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}
