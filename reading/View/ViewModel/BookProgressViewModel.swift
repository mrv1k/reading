//
//  BookProgressViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-11.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class BookProgressViewModel: ObservableObject {
    @Published var completionPercent: Double = 0
    @Published var completionPage: Int = 0
    @Published var completionPageLabel: String = ""

    var valueLabel: String { "\(Int(completionPercent))% / \(completionPageLabel)" }

    init(book: Book, showLabel: Bool) {
        book.publisher(for: \.raw_completionPercent)
            .map({ Helpers.percentCalculator.rounded($0) })
            .assign(to: &$completionPercent)

        let completionPagePublisher = book.publisher(for: \.completionPage)
            .map({ Int($0) })

        completionPagePublisher
            .assign(to: &$completionPage)

        completionPagePublisher
            .map { makeNounWithPluralForm(count: $0, word: "page") }
            .assign(to: &$completionPageLabel)
    }

}


func makeNounWithPluralForm(count: Int, word : String) -> String {
    let possiblePlural = count == 1 ? word : word + "s"
    return "\(count) \(possiblePlural)"
}

