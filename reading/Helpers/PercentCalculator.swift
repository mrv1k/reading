//
//  PercentCalculator.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-06.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct PercentCalculator {
    var modifier = getModifierFromCoreDataAttributes()

    func get(part: Int16, of total: Int16) -> Int16 {
        let percentage = Float(part) / Float(total) * 100
        // Multiply by modifier to keep N fractional number(s).
        // By 10 to keep 1 fractional, or more for more
        return Int16((percentage * modifier).rounded())
    }

    func rounded<AnyInt: BinaryInteger>(_ percent: AnyInt) -> Double {
        (Double(percent) / Double(modifier)).rounded()
    }
}

fileprivate func getModifierFromCoreDataAttributes() -> Float {
    let bookAttribute = getAttribute(description: Book.entity(), attribute: #keyPath(Book.raw_completionPercent))
    let sessionAttribute = getAttribute(description: Session.entity(), attribute: #keyPath(Session.raw_progressPercent))

    guard let bookModifier = Float(bookAttribute),
          let sessionModifier = Float(sessionAttribute)
    else { fatalError("Book/Session modifier attribute failed to convert to Float") }

    guard bookModifier == sessionModifier else {
        fatalError("Book/Session modifier out of sync")
    }

    return bookModifier
}

fileprivate func getAttribute(description: NSEntityDescription, attribute: String) -> String {
    description.attributesByName[attribute]?.userInfo?["percentageModifier"]! as! String
}
