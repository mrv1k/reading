//
//  BookProgressViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-11.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class BookProgressViewModel: ViewModel {
    var showLabel: Bool
    @Published var completionPercent: Double = 0
    @Published var valueLabel: String = ""

    init(book: DomainBook, showLabel: Bool) {
        self.showLabel = showLabel

        var stub = 69
        let completionPercentPublisher = stub

//            book.publisher(for: \.raw_completionPercent)
//            .map { Helpers.percentCalculator.rounded($0) }

//        completionPercentPublisher.assign(to: &$completionPercent)
//
//        guard showLabel else { return }
//        completionPercentPublisher.combineLatest(book.publisher(for: \.completionPage))
//            .map { (percent: Double, page: Int16) in
//                let percentText = "\(Int(percent))%"
//
//                let pageNoun = page == 1 ? "page" : "pages"
//                let pageText = "\(page) \(pageNoun)"
//                // TODO: a setting to toggle between percent (default) and pages
//                return "\(percentText) done / \(pageText) of \(book.pageCount) pages"
//            }
//            .assign(to: &$valueLabel)
    }
}
