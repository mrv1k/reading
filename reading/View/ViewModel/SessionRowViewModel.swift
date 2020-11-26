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
    var time: String
    var progressPage: String
    var progressPercent: String
    var progress: String { settings.progressPercentage ? progressPercent : progressPage }

    init<AnyInt: BinaryInteger>(createdAt: Date, progressPage: AnyInt, raw_progressPercent: AnyInt) {
        time = Helpers.dateFormatters.time.string(from: createdAt)

        self.progressPage = "\(progressPage) \(progressPage == 1 ? "page" : "pages")"
        progressPercent = "\(AnyInt(Helpers.percentCalculator.rounded(raw_progressPercent)))%"
    }
}
