//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Session {
    // transient attribute
    @objc public var progressPercent: Int {
        PercentHelper.shared.rounded(raw_progressPercent)
    }

    public func computeMissingAttributes() {
        guard let book = book else { return }

        let count = Int(book.sessionCount)
        // print(count, createdAt, pageEnd)

        let isFirst = count == 0
        pageStart = isFirst ? 0 : book.sessions[count - 1].pageEnd

        if !isFirst {
            let current = createdAt
            let previous = book.sessions[count - 1].createdAt
            let comparison = Calendar.current.isDate(current, inSameDayAs: previous)

            // print("isSameDay", count, "vs", count - 1, comparison)
            isSameDay = comparison
        }

        progressPage = pageEnd - pageStart
        raw_progressPercent = PercentHelper.shared
            .get(part: progressPage, of: book.pageCount)
    }
}
