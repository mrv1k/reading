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

    @Published var isInPercents = false
    private var progressPage = 0
    private var progressPercent = 0
    @Published private var progressPageText = ""
    @Published private var progressPercentText = ""
    var progressText: String {
        print("progresstext", isInPercents ? progressPercentText : progressPageText)
        return isInPercents ? progressPercentText : progressPageText
    }

    var time = ""

    var progressBinding: String {
        get { String(isInPercents ? progressPercent : progressPage) }
        set {
            guard let progress = Int(newValue) else { return }
            print(newValue, "progress", progress)
            if isInPercents {
                progressPercent = progress
                progressPercentText = "\(progress)%"
            } else {
                progressPage = progress
                progressPageText = "\(progress) page(s)"
            }
        }
    }

    init(session: Session) {
        self.session = session

        progressPercent = session.progressPercent
        progressPage = Int(session.progressPage)

        settings.$sessionIsInPercents.assign(to: &$isInPercents)

        time = Helpers.dateFormatters.time.string(from: session.createdAt)
        $session
            .map(\.progressPage)
            .print()
            .map { page in "\(page) \(page == 1 ? "page" : "pages")" }
            .assign(to: &$progressPageText)

        $session
            .map(\.progressPercent)
            .print()
            .map { "\($0)%" }
            .assign(to: &$progressPercentText)
    }
}
