//
//  BookVIewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-25.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

// WHAT THE NAME

class BookViewModel {
    @Published var completionPercent: Int

    init(book: Book) {
        completionPercent = book.completionPercent
    }
}
