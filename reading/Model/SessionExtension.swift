//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Session {
    @objc public var progressPercent: Int {
        PercentHelper.shared.rounded(raw_progressPercent)
    }

    // TODO: compute if 2 or more session were on the same day and store it in transietn prop
    public func computeMissingProperties() {
        if let book = book {
            if book.sessionCount == 0 {
                pageStart = 0
            } else {
                pageStart = book.sessions[Int(book.sessionCount) - 1].pageEnd
            }

            progressPage = pageEnd - pageStart
            raw_progressPercent = PercentHelper.shared
                .get(part: progressPage, of: book.pageCount)
        }
    }
}
