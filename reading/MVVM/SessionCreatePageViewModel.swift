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
    @Published var field = ""
    @Published var validation = [String]()

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        isValid.sink { status in
            print(status)
        }.store(in: &cancellableSet)
    }

    private var debouncedInput: AnyPublisher<String, Never> {
        $field
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private var isEmpty: AnyPublisher<Bool, Never> {
        debouncedInput
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    var isNumber: AnyPublisher<Bool, Never> {
        debouncedInput
            .map { Int($0) == nil ? false : true }
            .eraseToAnyPublisher()
    }

    var isPositiveNumber: AnyPublisher<Bool, Never> {
        debouncedInput
            .map { Int($0) ?? -1 }
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }

    var isValid: AnyPublisher<FieldCheck, Never> {
        Publishers.CombineLatest3(isEmpty, isNumber, isPositiveNumber)
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
}
