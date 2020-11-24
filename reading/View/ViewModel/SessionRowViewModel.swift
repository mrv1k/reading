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
    @Published var showDayLabelForReverseArray = false
    var time: String
    var date: String
    var progressPage: String
    var progressPercent: String
    var progress: String { settings.progressPercentage ? progressPercent : progressPage }

    init<AnyInt: BinaryInteger>(
        createdAt: Date,
        progressPage: AnyInt,
        raw_progressPercent: AnyInt,
        reverse_showDayLabelPublisher: AnyPublisher<Bool, Never>
    ) {
        time = Helpers.dateFormatters.time.string(from: createdAt)
        date = Calendar.current.isDateInToday(createdAt) ? "Today" :
            Helpers.dateFormatters.date.string(from: createdAt)

        self.progressPage = "\(progressPage) \(progressPage == 1 ? "page" : "pages")"
        progressPercent = "\(AnyInt(Helpers.percentCalculator.rounded(raw_progressPercent)))%"

        reverse_showDayLabelPublisher.assign(to: &$showDayLabelForReverseArray)
    }
}
