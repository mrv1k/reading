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
    @Published var progressInput = ""
    @Published private var progress = Progress.empty
    var progressText: String { progress.getText() }

    init(session: Session) {
        self.session = session
        time = Helpers.dateFormatters.time.string(from: session.createdAt)

        settings.$sessionIsInPercents.assign(to: &$isInPercents)

        progressInput = String(isInPercents ? session.progressPercent : Int(session.progressPage))

        $progressInput.combineLatest($isInPercents)
            .map { (input, isInPercents) -> Progress in
                guard let number = Int(input) else { return .empty }
                return Progress(number, isInPercents: isInPercents)
            }
            .assign(to: &$progress)
    }
}

extension SessionRowViewModel {
    enum Progress {
        case empty
        case page(Int)
        case percent(Int)

        init(_ progress: Int, isInPercents: Bool) {
            if isInPercents {
                self = .percent(progress)
            } else {
                self = .page(progress)
            }
        }

        func getText() -> String {
            switch self {
            case let .page(progress): return "\(progress) \(progress == 1 ? "page" : "pages")"
            case let .percent(progress): return "\(progress)%"
            default: return ""
            }
        }
    }
}
