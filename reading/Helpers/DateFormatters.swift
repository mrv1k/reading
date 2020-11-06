//
//  DateFormatters.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-06.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

struct DateFormatterHelper {
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
