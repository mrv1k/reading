//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Session {
    public func computeMissingAttributes() {
        guard let book = book else { fatalError("book attribute is missing") }
        guard pageEnd > 0 else { fatalError("pageEnd is not a valid number") }

        let count = Int(book.sessionCount)
        let isFirst = count == 0

        if isFirst {
            pageStart = 0
        } else {
            let previous = book.sessions[count - 1]

            pageStart = previous.pageEnd

            previous.reverse_showDayLabel = showPreviousDayLabel(
                previous.createdAt, current: createdAt)
        }

        progressPage = pageEnd - pageStart

        raw_progressPercent = Helpers.percentCalculator
            .get(part: progressPage, of: book.pageCount)

        book.completionPage += progressPage
        book.raw_completionPercent += raw_progressPercent
    }

    private func showPreviousDayLabel(_ previous: Date, current: Date) -> Bool {
        !Calendar.current.isDate(previous, inSameDayAs: current)
    }

}
