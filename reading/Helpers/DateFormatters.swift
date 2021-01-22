//
//  DateFormatters.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-06.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

struct DateFormatterHelper {
    var date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        return formatter
    }()

    var time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
