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

    var key: String { self.rawValue }
}
