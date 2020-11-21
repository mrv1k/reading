//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

class SessionRowViewModel: ViewModel, AppSettingsObserver, Identifiable {
    private var session: Session

    @Published var showDayLabelForReverseArray = false

    init(session: Session) {
        self.session = session
        session.publisher(for: \.reverse_showDayLabel).assign(to: &$showDayLabelForReverseArray)
    }

    var createdAt: Date { session.createdAt }
    var weekDay: String { Helpers.dateFormatters.day.string(from: session.createdAt) }
    var monthDay: String { Helpers.dateFormatters.month.string(from: session.createdAt) }

    var progress: String { settings.progressPercentage ? progressPercent : progressPage }

    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }

    var progressPercent: String {
        "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}
