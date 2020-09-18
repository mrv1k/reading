//
//  SessionCreatePagesViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

enum Validity {
    case valid
    case invalid(reason: String)
}

enum FieldCheck {
    case valid
    case empty
    case notNumber
    case negativeNumber
}

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField = ""
    @Published var endField = ""
    @Published var progressField = ""

    @Published var startValidation = [String]()
    @Published var endValidation = [String]()
    @Published var progressValidation = [String]()

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        Publishers.CombineLatest3($startField, $endField, $progressField)
            .sink { arg in
                print(arg)
            }
            .store(in: &cancellableSet)


        let start = fieldValidationPipeline(published: $startField, name: .start)
        let end = fieldValidationPipeline(published: $endField, name: .end)
        let progress = fieldValidationPipeline(published: $progressField, name: .progress)

        validationMessagePipeline(validatedField: start)
            .assign(to: &$startValidation)
        validationMessagePipeline(validatedField: end)
            .assign(to: &$endValidation)
        validationMessagePipeline(validatedField: progress)
            .assign(to: &$progressValidation)

        print("cancellableSet", cancellableSet)

        startIsValidPublisher.sink { check in
            print(check)
        }
        .store(in: &cancellableSet)

    }

    private var startDebounce: AnyPublisher<String, Never> {
        $startField
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var startIsEmpty: AnyPublisher<Bool, Never> {
        startDebounce
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    var startIsNumber: AnyPublisher<Bool, Never> {
        startDebounce
            .map { Int($0) == nil ? false : true }
            .eraseToAnyPublisher()
    }

    var startIsPositiveNumber: AnyPublisher<Bool, Never> {
        startDebounce
            .map { Int($0) ?? -1 }
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }

    var startIsValidPublisher: AnyPublisher<FieldCheck, Never> {
        Publishers.CombineLatest3(startIsEmpty, startIsNumber, startIsPositiveNumber)
            .map { (isEmpty, isNumber, isPositive) in
                if isEmpty {
                    return .empty
                }
                if !isNumber {
                    return .notNumber
                }
                if !isPositive {
                    return .negativeNumber
                }

                return .valid
            }
            .eraseToAnyPublisher()
    }



    func fieldValidationPipeline(published: Published<String>.Publisher, name: Field) -> AnyPublisher<Validity, Never> {
        print(name)
        return published
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .map({ fieldInput -> Validity in
                if fieldInput.isEmpty {
                    return .invalid(reason: "\(name.rawValue) field is required")
                }

                guard let number = Int(fieldInput) else {
                    return .invalid(reason: "Page fields must be numeric")
                }
                if number < 0 {
                    return .invalid(reason: "Page fields must be positive numbers")
                }
                return .valid
            }).eraseToAnyPublisher()
    }

    func validationMessagePipeline(validatedField: AnyPublisher<Validity, Never>) -> AnyPublisher<[String], Never>  {
        return validatedField
            .map({ (validity) -> [String] in
                var messages = [String]()
                print("messages", messages)
                switch validity {
                case .invalid(let reason):
                    messages.append(reason)
                default:
                    break
                }
                print("messages", messages)

                return messages
            }).eraseToAnyPublisher()
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

    enum Field: String {
        case start = "Start page"
        case end = "End page"
        case progress = "Progress"
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
