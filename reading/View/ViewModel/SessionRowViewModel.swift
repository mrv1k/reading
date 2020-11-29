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
    var time = ""

    @Published var isInPercents = false
    @Published private var progressPage = 0
    @Published private var progressPercent = 0
    private var progressPercentText = ""
    private var progressPageText = ""

    var progressText: String {
        get { isInPercents ? progressPercentText : progressPageText }
        set(progress) {
            if isInPercents {
                progressPercentText = "\(progress)%"
            } else {
                progressPageText = "\(progress) \(progress == "1" ? "page" : "pages")"
            }
        }
    }

    var progressBinding: String {
        get { String(isInPercents ? progressPercent : progressPage) }
        set {
            guard let progress = Int(newValue) else { return }
            if isInPercents {
                progressPercent = progress
            } else {
                progressPage = progress
            }
            progressText = String(progress)
        }
    }

    init(session: Session) {
        self.session = session

        settings.$sessionIsInPercents.assign(to: &$isInPercents)
        progressPercent = session.progressPercent
        progressPage = Int(session.progressPage)
        progressText = String(isInPercents ? session.progressPercent : Int(session.progressPage))

        time = Helpers.dateFormatters.time.string(from: session.createdAt)
    }
}
