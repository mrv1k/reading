//
//  UserDefaultsKey.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-12.
//  Copyright © 2020 mrv1k. All rights reserved.
//

/// Key collection for UserDefaults
enum UserDefaultsKey: String {
    /// Used in: `BookSort`
    case bookSort, sortByTitle, sortByAuthor, sortByCreatedAt
    /// Used in: `AppSettings`
    case progressPercentage, sessionsIsSortingByNewest
}
