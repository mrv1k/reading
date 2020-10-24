//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

// import Foundation
import Combine
import SwiftUI

class SessionListBookViewModel: ObservableObject {
    let book: Book

    var sessionRowViewModelList: [SessionRowViewModel] {
        book.sessionsReversed.map { session in
            print("map")
            return SessionRowViewModel(session: session)
        }
    }

    @Published var pageProgressStyle: PageProgressStyle = .page
    @Published var timeStyle: Text.DateStyle = .time

    init(book: Book) {
        print("init fired")
        self.book = book
    }

    var timePrefix: String { timeStyle == .time ? "at " : "" }
    var timeSuffix: String { timeStyle == .relative ? " ago" : "" }

    func toggleTimeStyle() {
        timeStyle = timeStyle == .time ? .relative : .time
    }

    enum PageProgressStyle {
        case page, percent
    }

    func togglePageProgressStyle() {
        pageProgressStyle = pageProgressStyle == .page ? .percent : .page
    }
}
