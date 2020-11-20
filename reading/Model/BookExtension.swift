//
//  BookExtension.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-13.
//  Copyright © 2020 mrv1k. All rights reserved.
//

extension Book {
    /// Does not support KVO
    public var sessions: [Session] {
        sessionsSet?.array as? [Session] ?? []
    }

    // It's typically advised to avoid making to Array conversion
    // https://www.donnywals.com/reversing-an-array-in-swift/
//    public var sessionsReversed: [Session] {
//        sessionsSet?.reversed.array as? [Session] ?? []
//    }
}
