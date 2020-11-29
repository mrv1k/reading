//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

class SessionRowViewModel: ViewModel, AppSettingsObserver, Identifiable {
    var settings: AppSettings { AppSettings.singleton }

    @Published var session: Session

    var time: String

    @Published var progressPage = ""
    @Published var progressPercent = ""
    @Published var isInPercents = false

    var progress: String {
        get { isInPercents ? progressPercent : progressPage }
        set {
            if isInPercents {
                progressPercent = newValue
            } else {
                progressPage = newValue
            }
        }
    }

    init(session: Session) {
        self.session = session

        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        settings.$sessionIsInPercents.assign(to: &$isInPercents)

        $session.map(\.progressPage)
            .map { page in "\(page) \(page == 1 ? "page" : "pages")" }
            .assign(to: &$progressPage)

        $session.map(\.progressPercent)
            .map { "\($0)%" }
            .assign(to: &$progressPercent)
    }
}

// refactor: add transient progressPercent attribute to Session entity
