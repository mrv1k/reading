//
//  BookExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

extension Book {
    @objc dynamic var sessions: [Session] {
        sessionsSet?.array as? [Session] ?? []
    }

    @objc dynamic var sessionsReversed: [Session] {
        sessions.reversed()
    }
}
