//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

public extension Session {
    func computeMissingAttributes() {
        guard let book = book else { fatalError("book attribute is missing") }
        guard pageEnd > 0 else { fatalError("pageEnd is not a valid number") }

        // Session that's being created is included in count, substract -1 to account for it
        let count = book.sessions.count - 1
        let isFirst = count == 0

        pageStart = isFirst ? 0 : book.sessions[count - 1].pageEnd

        progressPage = pageEnd - pageStart
        raw_progressPercent = Helpers.percentCalculator
            .get(part: progressPage, of: book.pageCount)

        book.completionPage += progressPage
        book.raw_completionPercent += raw_progressPercent

        if book.completionPage == book.pageCount {
            book.completed = true
        }
    }
}
