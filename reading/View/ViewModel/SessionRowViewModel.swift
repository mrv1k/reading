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
    let session: Session

    var time: String
    var progressPage: String
    var progressPercent: String
    var progress: String { settings.progressPercentage ? progressPercent : progressPage }

    init(session: Session) {
        self.session = session

        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        progressPage = "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
        progressPercent = "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}
