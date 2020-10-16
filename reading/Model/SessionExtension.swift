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
            // TODO: move count to derived attribute on book
            if book.sessions.count == 1 {
                pageStart = 0
            } else {
                // - 1 for count, - 1 for current session
                pageStart = book.sessions[book.sessions.count - 2].pageEnd
            }

            progressPage = pageEnd - pageStart
            raw_progressPercent = PercentHelper.shared
                .get(part: progressPage, of: book.pageCount)
        }
    }
}
