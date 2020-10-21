//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

private var dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E"
    return formatter
}()

private var monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    return formatter
}()

class SessionRowViewModel: ObservableObject, Identifiable {
    var session: Session

    var weekDay: String
    var monthDate: String

    lazy var progressPage = "\(session.progressPage) pages"
    lazy var progressPercent = "\(session.progressPercent)%"

    init(session: Session) {
        self.session = session
        weekDay = dayFormatter.string(from: session.createdAt)
        monthDate = monthFormatter.string(from: session.createdAt)
    }
}
