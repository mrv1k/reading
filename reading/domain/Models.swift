//
//  Models.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

struct DomainBook: Equatable {
    let title: String
    let author: String
    let pageCount: Int
    var persistenceID: UUID? = nil

    static func == (lhs: DomainBook, rhs: DomainBook) -> Bool {
        return lhs.title == rhs.title &&
            lhs.author == rhs.author &&
            lhs.pageCount == rhs.pageCount
    }
}
