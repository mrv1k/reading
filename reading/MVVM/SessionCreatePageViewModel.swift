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
    @Published var validation = ""
    @Published var pristine = true

    init() {
        fieldValidationPublisher
            .assign(to: &$validation)
    }

    func onEditingChanged(_: Bool) {
        pristine = false
    }

    private var debouncedInput: AnyPublisher<String, Never> {
        $input
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    private var isEmpty: Publishers.Map<AnyPublisher<String, Never>, Bool> {
        debouncedInput.map { $0.isEmpty }
    }

    var page: Publishers.Map<AnyPublisher<String, Never>, Int?> {
        debouncedInput.map { Int($0) }
    }

    var fieldValidationPublisher: AnyPublisher<String, Never> {
        Publishers.CombineLatest3($pristine, isEmpty, page)
            .map { (pristine, isEmpty, page) in
                if pristine {
                    return "pristine"
                }

                if isEmpty {
                    return "Cannot be blank"
                }

                guard let number = page else {
                    return "Must be a number"
                }

                if number < 1 {
                    return "Must be a positive number"
                }

                return ""
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
