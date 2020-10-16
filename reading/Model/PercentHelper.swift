//
//  PercentHelper.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct PercentHelper {
    static let shared = PercentHelper()

    var modifier: Float = 0

    func get(part: Int16, of total: Int16) -> Int16 {
        let percentage = Float(part) / Float(total) * 100
        // multiply by modifier (10) to keep N (1) fractional number(s)
        return Int16((percentage * modifier).rounded())
    }

    func rounded(_ percent: Int16) -> Int {
        return Int((Float(percent) / PercentHelper.shared.modifier).rounded())
        // return (temp.rounded())
    }

    private func getModifier(description: NSEntityDescription, attribute: String) -> Float {
        Float(description.attributesByName[attribute]?.userInfo?["percentageModifier"]! as! String)!
    }

    init() {
        let bookModifier = getModifier(description: Book.entity(), attribute: "raw_completionPercent")
        let sessionModifier = getModifier(description: Session.entity(), attribute: "raw_progressPercent")

        if bookModifier != sessionModifier {
            fatalError("Book and Session modifiers must match")
        }
        modifier = bookModifier
    }
}
