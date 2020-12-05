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
    var time = ""

    @Published private var isInPercents = false
    @Published var progressPage = ""
    @Published var progressPercent = ""
    var progress: String { isInPercents ? progressPercent : progressPage }

    var progressTrailingText: String { isInPercents ? "%" : (progressPage == "1" ? " page" : " pages") }

    init(session: Session) {
        self.session = session
        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        AppSettings.singleton.$sessionIsInPercents.assign(to: &$isInPercents)

        $session.map(\.progressPage).map { String($0) }.assign(to: &$progressPage)
        $session.map(\.progressPercent).map { String($0) }.assign(to: &$progressPercent)
    }
}
