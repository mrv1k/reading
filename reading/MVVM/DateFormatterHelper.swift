//
//  DateFormatterHelper.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-24.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

class DateFormatterHelper {
    static var shared = DateFormatterHelper()

    var day: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()

    var month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()
}
