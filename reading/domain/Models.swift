//
//  Models.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

struct DomainBook {
    var id: UUID?
    let title: String
    let author: String
    let pageCount: Int
}
