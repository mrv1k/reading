//
//  UserKeys.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

/// Key collection for UserDefaults
enum UserKeys: String {
    /// Uses `BookSort`
    case bookSort
    case title
    case author
    case createdAt

    static func getAscending(forSort sort: BookSort) -> String {
        switch sort {
        case .title: return Self.title.rawValue
        case .author: return Self.author.rawValue
        case .createdAt: return Self.createdAt.rawValue
        }
    }
}
