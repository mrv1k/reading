//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-10-20.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation

class SessionListBookViewModel: ObservableObject {
    var sessionsRowViewModels: [SessionRowViewModel]

    @Published var pageProgressStyle: PageProgressStyle = .page

    init(session: [Session]) {
        sessionsRowViewModels = session.map({ session in
            SessionRowViewModel(session: session)
        })
    }

    enum PageProgressStyle {
        case page, percent
    }

    func togglePageProgressStyle() {
        pageProgressStyle = pageProgressStyle == .page ? .percent : .page
    }
}
