//
//  SessionCreatePagesViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
// import for debounce scheduler
import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField = ""
    @Published var endField = ""
    @Published var progressField = ""
    @Published var validationMessages = [String]()

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        /*
         TODO:
         if can be autofilled
         compute autofills
         display autofill button
         */

        let fields = Publishers.Merge3($startField, $endField, $progressField)
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .map({ fieldInput -> Int? in
                guard !fieldInput.isEmpty else { return nil }

                let onlyDigits = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: fieldInput))
                return onlyDigits ? Int(fieldInput) : -1
            }).eraseToAnyPublisher()


        fields
            .sink(receiveValue: { (value) in
                print("fields sink:", value)
            })
            .store(in: &cancellableSet)

        fields
            .map({ (page) -> [String] in
                var messages = [String]()

                if page == -1 {
                    messages.append("Fields must only contain numbers")
                }
//                TODO: Fields must be a positive number
                return messages
            })
            .assign(to: &$validationMessages)

        print("cancellableSet", cancellableSet)
    }

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

    private var inputCombination: InputCombination? {
        InputCombination.determine(startIsValid, endIsValid, progressIsValid)
    }

    func canBeAutofilled(field: Field) -> Bool {
        if let combination = inputCombination {
            switch field {
            case .start:
                return InputCombination.toAutofillStart.contains(combination)
            case .end:
                return InputCombination.toAutofillEnd.contains(combination)
            case .progress:
                return InputCombination.toAutofillProgress.contains(combination)
            }
        }
        return false
    }
}


extension SessionCreatePagesViewModel {
    private enum InputCombination {
        case startAndEnd, startAndProgress, onlyEnd, onlyProgress

        static var toAutofillStart: [Self] { [.onlyProgress, .onlyEnd] }
        static var toAutofillEnd: [Self] { [.onlyProgress, .startAndProgress] }
        static var toAutofillProgress: [Self] { [.onlyEnd, .startAndEnd] }

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

    enum Field {
        case start, end, progress
    }

    func autofill(field: Field) {
        print(field)
        // FIXME: onlyEnd and onlyProgress no longer work without a start page first
        // solution1 : display only start at first

        switch field {
        case .start:
            print("start", startField, computedStart)
            startField = computedStart
        case .end:
            print("end", endField, computedEnd)
            endField = computedEnd
        case .progress:
            print("progress", progressField, computedProgress)
            progressField = computedProgress
        }

        // switch inputCombination {
        // case .startAndEnd:
        //     progressField = computedProgress
        // case .startAndProgress:
        //     endField = computedEnd
        // case .onlyEnd:
        //     startField = computedStart
        //     progressField = computedProgress
        // case .onlyProgress:
        //     startField = computedStart
        //     endField = computedEnd
        // default:
        //     break
        // }
    }
}
