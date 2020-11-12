//
//  BookProgress.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookProgress: View {
    var showLabel: Bool

    @StateObject var viewModel: BookProgressViewModel

    init(book: Book, showLabel: Bool = false) {
        let viewModel = BookProgressViewModel(book: book, showLabel: showLabel)
        _viewModel = StateObject(wrappedValue: viewModel)
        self.showLabel = showLabel
    }

    var body: some View {
        if showLabel {
            ProgressView(value: viewModel.completionPercent, total: 100)
            {} // label: () -> _,
            currentValueLabel: { Text(viewModel.valueLabel) }
        } else {
            ProgressView(value: viewModel.completionPercent, total: 100)
        }
    }
}

struct BookProgress_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookProgress(book: BookSeeder.preview.fetch(bookWith: .sessions))

            BookProgress(book: BookSeeder.preview.fetch(bookWith: .sessions))

        }.previewLayout(.sizeThatFits)
    }
}
