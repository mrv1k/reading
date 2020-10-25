//
//  BookRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-25.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class BookRowViewModel: ObservableObject {
    @Published var completionPercent: Int
    @Published var raw_completionPercent: Int

    init(book: Book) {
        completionPercent = book.completionPercent
        raw_completionPercent = Int(book.raw_completionPercent)
    }
}

