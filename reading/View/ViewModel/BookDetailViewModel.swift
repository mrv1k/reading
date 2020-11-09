//
//  BookDetailViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class BookDetailViewModel: ObservableObject {
    var book: Book

    @Published var completionPercent: Double = 0

    init(book: Book) {
        self.book = book

        book.publisher(for: \.raw_completionPercent)
            .map({ Helpers.percentCalculator.rounded($0) })
            .assign(to: &$completionPercent)
    }

}
