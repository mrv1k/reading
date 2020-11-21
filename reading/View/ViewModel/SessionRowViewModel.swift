//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

class SessionRowViewModel: ViewModel, Identifiable, AppSettingsObserver {
    private var session: Session
    @Published var showDayLabelForReverseArray: Bool

    init(session: Session) {
        print("row init")
        self.session = session
        showDayLabelForReverseArray = session.reverse_showDayLabel
    }

    var createdAt: Date { session.createdAt }
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
