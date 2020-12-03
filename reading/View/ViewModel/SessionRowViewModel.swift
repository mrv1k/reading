//
//  SessionRowViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

class SessionRowViewModel: ViewModel, Identifiable {
    @Published var session: Session
    @Published var isNewSession: Bool
    var time = ""

    @Published private var isInPercents = false
    @Published var progressPage = ""
    @Published var progressPercent = ""
    var progressPlaceholder = ""
    var progressInput: String {
        get { isInPercents ? progressPercent : progressPage }
        set {
            if isInPercents {
                progressPercent = newValue
            } else {
                progressPage = newValue
            }
        }
    }

    var progressTrailingText: String { isInPercents ? "%" : (progressPage == "1" ? " page" : " pages") }

    init(session: Session, isNewSession: Bool = false) {
        self.session = session
        self.isNewSession = isNewSession
        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        AppSettings.singleton.$sessionIsInPercents.assign(to: &$isInPercents)

        $session.map(\.progressPage).map { String($0) }.assign(to: &$progressPage)
        $session.map(\.progressPercent).map { String($0) }.assign(to: &$progressPercent)

        if isNewSession {
            progressInput = ""
        }
        progressPlaceholder = (isInPercents ? progressPercent : progressPage) + progressTrailingText
    }

}

