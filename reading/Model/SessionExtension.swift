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

    // TODO: compute if 2 or more session were on the same day and store it in transietn prop
    public func computeMissingAttributes() {
        guard let book = book else { return }

        let count = Int(book.sessionCount)

        let isFirst = count == 0
        pageStart = isFirst ? 0 : book.sessions[count - 1].pageEnd

        progressPage = pageEnd - pageStart
        raw_progressPercent = PercentHelper.shared
            .get(part: progressPage, of: book.pageCount)
    }
}
