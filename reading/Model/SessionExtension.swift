//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Session {
    // transient
    @objc public var progressPercent: Int {
        PercentHelper.shared.rounded(raw_progressPercent)
    }

    public func computeMissingAttributes() {
        guard let book = book else { fatalError("\(#function): book attribute is missing") }

        let count = Int(book.sessionCount)
        let isFirst = count == 0

        if isFirst {
            pageStart = 0
        } else {
            let previous = book.sessions[count - 1]
            let current = book.sessions[count]

            pageStart = previous.pageEnd

            let dayComparison = Calendar.current.isDate(current.createdAt, inSameDayAs: previous.createdAt)
            isSameDay = dayComparison
        }

        progressPage = pageEnd - pageStart

        raw_progressPercent = PercentHelper.shared
            .get(part: progressPage, of: book.pageCount)
    }
}
