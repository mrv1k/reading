//
//  SessionExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Session {
    public func autofillProgress() {
        // TODO: dont write start if it exists

        if let book = book {
            if book.sessions.count == 1 {
                pageStart = 0
            } else {
                // - 1 for count, - 1 for current session
                pageStart = book.sessions[book.sessions.count - 2].pageEnd
            }

            progressPage = pageEnd - pageStart
            progressPercent = PercentHelper.shared
                .get(part: progressPage, of: book.pageCount)
        }
    }
}
