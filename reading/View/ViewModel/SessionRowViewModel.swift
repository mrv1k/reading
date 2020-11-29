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
    @Published var session: Session

    var time: String

    @Published var progressPage = ""
    @Published var progressPercent = ""
    @Published var settignsProgressPercentage = false
    
    var progress: String {
        get { settignsProgressPercentage ? progressPercent : progressPage }
        set {
            if settignsProgressPercentage {
                progressPercent = newValue
            } else {
                progressPage = newValue
            }
        }
    }

    init(session: Session) {
        self.session = session

        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        AppSettings.singleton.$progressPercentage.assign(to: &$settignsProgressPercentage)

        $session.map(\.progressPage)
            .map { page in "\(page) \(page == 1 ? "page" : "pages")" }
            .assign(to: &$progressPage)

        $session.map(\.progressPercent)
            .map { "\($0)%" }
            .assign(to: &$progressPercent)

//        progressPercent = "\(Int(Helpers.percentCalculator.rounded(session.raw_progressPercent)))%"
    }
}

// refactor: add transient progressPercent attribute to Session entity
