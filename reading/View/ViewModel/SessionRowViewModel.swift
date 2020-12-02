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
    @Published private var isInPercents = false

    @Published var session: Session
    var time = ""
    @Published var progressPage = ""
    @Published var progressPercent = ""

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
    var progressTrailingText: String {
        isInPercents ? "%" : (progressPage == "1" ? " page" : " pages")
    }
    @Published var progressTrailingTextHidden = false

    var progressPlaceholder: String { "stub" }

    init(session: Session) {
        self.session = session
        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        settings.$sessionIsInPercents.assign(to: &$isInPercents)

        $session.map(\.progressPage).map { String($0) }.assign(to: &$progressPage)
        $session.map(\.progressPercent).map { String($0) }.assign(to: &$progressPercent)
    }

    func hideProgressTrailingTextOnEditing(isEditing: Bool) {
        progressTrailingTextHidden = isEditing
    }
}

// extension SessionRowViewModel {
//    enum Progress {
//        case empty
//        case page(Int)
//        case percent(Int)
//
//        init(_ progress: Int, isInPercents: Bool) {
//            if isInPercents {
//                self = .percent(progress)
//            } else {
//                self = .page(progress)
//            }
//        }
//
//        func getText() -> String {
//            switch self {
//            case let .page(progress): return "\(progress) \(progress == 1 ? "page" : "pages")"
//            case let .percent(progress): return "\(progress)%"
//            default: return ""
//            }
//        }
//    }
// }
