//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData
import Combine
import SwiftUI

class SessionListBookViewModel: ObservableObject {
    private let book: Book

    @Published var pageEndField = ""
    // TODO: make persistent
    @Published var progressStyle = [SessionStyleProgress.page]
    @Published var timeStyle = [SessionStyleTime.time]

    init(book: Book) {
        self.book = book
    }

    // FIXME: currently fully recomputes when new session is added,
    // and when progress style or time style updates
    var sessionRowViewModels: [SessionRowViewModel] {
        print()
        return book.sessionsReversed.map { (session: Session) in
            print("fired")
            return SessionRowViewModel(
                session: session,
                progressStylePublisher: $progressStyle,
                timeStylePublisher: $timeStyle)
        }
    }

    func toggleTimeStyle() {
        timeStyle[0] = timeStyle[0] == .time ? .relative : .time
    }

    func toggleProgressStyle() {
        progressStyle[0] = progressStyle[0] == .page ? .percent : .page
    }

    func save(context: NSManagedObjectContext) {
        let session = Session(context: context)
        session.book = book
        session.pageEnd = Int16(pageEndField)!
        try! context.saveOnChanges(session: session)
        pageEndField = ""
    }
}

enum SessionStyleProgress {
    case page
    case percent
}

enum SessionStyleTime {
    case time
    case relative

    var type: Text.DateStyle {
        switch self {
        case .time: return Text.DateStyle.time
        case .relative: return Text.DateStyle.relative
        }
    }
}
