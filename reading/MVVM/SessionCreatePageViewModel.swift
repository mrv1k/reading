//
//  SessionCreatePageViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-19.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Foundation
import Combine

class SessionCreatePageViewModel: ObservableObject {
    @Published var input = ""
    @Published var validation: PageFieldValidation = .pristine
    @Published var pristine = true
    @Published var page: Int?

    init() {
        fieldValidationPublisher.assign(to: &$validation)
        pagePublisher.assign(to: &$page)
    }

    func onEditingChanged(_: Bool) {
        pristine = false
    }

    private var debouncedInput: AnyPublisher<String, Never> {
        $input
            // FIXME: Debounce is a problem later down the chain for many publishers
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private var isEmpty: Publishers.Map<AnyPublisher<String, Never>, Bool> {
        debouncedInput.map { $0.isEmpty }
    }

    var pagePublisher: Publishers.Map<AnyPublisher<String, Never>, Int?> {
        debouncedInput.map { Int($0) }
    }

    var fieldValidationPublisher: AnyPublisher<PageFieldValidation, Never> {
        Publishers.CombineLatest3($pristine, isEmpty, pagePublisher)
            .map { (pristine, isEmpty, page) in
                if pristine { return .pristine }
                if isEmpty { return .empty }

                guard let number = page else {
                    return .invalidNumber
                }

                if number < 1 {
                    return .negativeNumber
                }

                return .valid
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

enum PageFieldValidation: String {
    case pristine = "pristine"
    case empty = "Cannot be blank"
    case invalidNumber = "Must be a number"
    case negativeNumber = "Must be positive a number"
    case valid = ""

    var isValid: Bool { self == .valid }

    var notFilled: Bool {
        [Self.pristine, Self.empty].contains(self)
    }
}
