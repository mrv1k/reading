//
//  BookProgress.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookProgress: View, ViewModelObserver {
    @StateObject var viewModel: BookProgressViewModel

    init(book: DomainBook, showLabel: Bool = false) {
        _viewModel = StateObject(wrappedValue: BookProgressViewModel(book: book, showLabel: showLabel))
    }

    var body: some View {
        if viewModel.showLabel {
            ProgressView(value: viewModel.completionPercent, total: 100) {} // label: () -> _,
            currentValueLabel: { Text(viewModel.valueLabel) }
        } else {
            ProgressView(value: viewModel.completionPercent, total: 100)
        }
    }
}

struct BookProgress_Previews: PreviewProvider {
    static var previews: some View {
//        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        // TODO: book should have progress prop
        let book = DomainBook(title: "titleA", author: "authorA", pageCount: 100)

        return Group {
            BookProgress(book: book, showLabel: true)

            BookProgress(book: book)

        }.previewLayout(.sizeThatFits)
    }
}
