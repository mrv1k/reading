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

    @Published var progressStyle = [SessionStyleProgress]()
    @Published var timeStyle = [SessionStyleTime]()

    init(session: Session,
         progressStylePublisher: Published<[SessionStyleProgress]>.Publisher,
         timeStylePublisher: Published<[SessionStyleTime]>.Publisher
         ) {

        self.session = session

        progressStylePublisher.assign(to: &$progressStyle)
        timeStylePublisher.assign(to: &$timeStyle)
    }

    var createdAt: Date { session.createdAt }
    var showDayLabelForReverseArray: Bool { session.reverse_showDayLabel }
    var weekDay: String { Helpers.dateFormatters.day.string(from: session.createdAt) }
    var monthDay: String { Helpers.dateFormatters.month.string(from: session.createdAt) }

    var progress: String {
        progressStyle[0] == .page ? progressPage : progressPercent
    }
    var progressPage: String {
        "\(session.progressPage) \(session.progressPage == 1 ? "page" : "pages")"
    }
    var progressPercent: String {
        "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}
