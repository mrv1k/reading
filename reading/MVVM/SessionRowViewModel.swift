//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

class SessionRowViewModel: ObservableObject, Identifiable {
    var session: Session

    var weekDay: String
    var monthDate: String

    var reverse_showDayLabel: Bool { session.reverse_showDayLabel }

    lazy var progressPage = "\(session.progressPage) pages"
    lazy var progressPercent = "\(session.progressPercent)%"

    init(session: Session) {
        print("Row init")
        self.session = session
        weekDay = DateFormatterHelper.shared.day.string(from: session.createdAt)
        monthDate = DateFormatterHelper.shared.month.string(from: session.createdAt)
    }
}
