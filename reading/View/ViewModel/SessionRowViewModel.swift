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

    @Published var progressInput = ""
    @Published var progressSymbol = ""
//    @Published var progressText = ""

    var progressPlaceholder: String { "stub" }

    init(session: Session) {
        self.session = session
        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        $session.map(\.progressPage).map { String($0) }.assign(to: &$progressPage)
        $session.map(\.progressPercent).map { String($0) }.assign(to: &$progressPercent)

        settings.$sessionIsInPercents.assign(to: &$isInPercents)

        progressInput = isInPercents ? progressPercent : progressPage
        progressSymbol = isInPercents ? "%" : (progressPage == "1" ? " page" : " pages")
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
