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

    init(session: [Session]) {
        sessionsRowViewModels = session.map({ session in
            SessionRowViewModel(session: session)
        })
    }
}
