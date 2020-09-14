//
//  SessionCreatePagesViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField = ""
    @Published var endField = ""
    @Published var progressField = ""

    var start: Int { Int(startField) ?? 0 }
    var end: Int { Int(endField) ?? 0 }
    var progress: Int { Int(progressField) ?? 0 }

    var startIsValid: Bool { start > 0 }
    var endIsValid: Bool { end > 0 }
    var endIsAfterStart: Bool { end > start }
    var progressIsValid: Bool { progress > 0 }

    // TODO: Should be smartly using last reading session page instead of 1
    var computedStart: String {
        endIsValid ? String(1) :
            progressIsValid ? String(1) : ""
    }
    var computedEnd: String {
        startIsValid && progressIsValid ? String(start + progress) : ""
    }
    var computedProgress: String {
        startIsValid && endIsAfterStart ? String(end - start) : ""
    }
}


extension SessionCreatePagesViewModel {
    var inputCombination: InputCombination? {
        InputCombination.determine(startIsValid, endIsValid, progressIsValid)
    }

    enum InputCombination {
        case startAndEnd, startAndProgress, onlyEnd, onlyProgress

        static func determine(_ startIsValid: Bool, _ endIsValid: Bool, _ progressIsValid: Bool) -> InputCombination? {
            let hasStart = true, hasEnd = true, hasProgress = true

            switch (startIsValid, endIsValid, progressIsValid) {
            case (false, hasEnd, false):
                return .onlyEnd
            case (false, false, hasProgress):
                return .onlyProgress
            case (hasStart, hasEnd, false):
                return .startAndEnd
            case (hasStart, false, hasProgress):
                return .startAndProgress
            default:
                return nil
            }
        }
    }

    func autofill() {
        switch inputCombination {
        case .startAndEnd:
            progressField = computedProgress
        case .startAndProgress:
            endField = computedEnd
        case .onlyEnd:
            startField = computedStart
            progressField = computedProgress
        case .onlyProgress:
            startField = computedStart
            endField = computedEnd
        default:
            break
        }
    }
}
