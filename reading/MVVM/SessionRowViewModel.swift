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

class SessionRowViewModel: ObservableObject {
    var model: Session

    var weekDay: String
    var monthDate: String

    init(session: Session) {
        model = session
        weekDay = dayFormatter.string(from: model.createdAt)
        monthDate = monthFormatter.string(from: model.createdAt)
    }
}
