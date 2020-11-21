//
//  BookProgress.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct BookProgress: View, ViewModelObserver {
    @ObservedObject var viewModel: BookProgressViewModel

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
        let book = BookSeeder.preview.fetch(bookWith: .sessions)
        let viewModel = BookProgressViewModel(book: book, showLabel: true)
        let viewModelNoLabel = BookProgressViewModel(book: book, showLabel: false)

        return Group {
            BookProgress(viewModel: viewModel)

            BookProgress(viewModel: viewModelNoLabel)

        }.previewLayout(.sizeThatFits)
    }
}
