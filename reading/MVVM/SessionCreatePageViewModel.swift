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
    @Published var fieldInput = ""
    @Published var validationMessage = ""

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        fieldValidationPublisher
            .assign(to: &$validationMessage)

        fieldValidationPublisher.sink {
            print($0)
        }.store(in: &cancellableSet)
    }

    private var input: AnyPublisher<String, Never> {
        $fieldInput
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var isEmpty: Publishers.Map<AnyPublisher<String, Never>, Bool> {
        input.map { $0.isEmpty }
    }

    var page: Publishers.Map<AnyPublisher<String, Never>, Int?> {
        input.map { Int($0) }
    }

    var fieldValidationPublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest(isEmpty, page)
            .map { (isEmpty, page) in
                if isEmpty {
                    return "is required"
                }

                guard let number = page else {
                    return "Must be a number"
                }
                if number < 0 {
                    return "Must not be a negative number"
                }

                return ""
            }
            .eraseToAnyPublisher()
    }
}
