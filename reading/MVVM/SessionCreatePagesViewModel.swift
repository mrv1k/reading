//
//  SessionCreatePagesViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

enum PageField: String {
    case start, end, progress
}

class SessionCreatePagesViewModel: ObservableObject {
    var startViewModel = SessionCreatePageViewModel()
    var endViewModel = SessionCreatePageViewModel()
    var progressViewModel = SessionCreatePageViewModel()

    @Published var autofillableFields = [PageField]()

    @Published var sectionValidaton = ""
    @Published var sectionIsValid = false

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        // autofillableFieldsPublisher.sink { (fields) in
        //     print("following fields can be autofilled:")
        //     for field in fields {
        //         print(field)
        //     }
        // }
        // .store(in: &cancellableSet)

        autofillableFieldsPublisher.assign(to: &$autofillableFields)

        sectionIsValidPublisher.assign(to: &$sectionIsValid)
    }

    private var sectionValidationPublisher: AnyPublisher<(PageFieldValidation, PageFieldValidation, PageFieldValidation), Never> {
        Publishers.CombineLatest3(
            startViewModel.$validation,
            endViewModel.$validation,
            progressViewModel.$validation
        )
        .eraseToAnyPublisher()
    }

    private var sectionIsValidPublisher: AnyPublisher<Bool, Never> {
        sectionValidationPublisher
            .map { (start, end, progress) in
                start.isValid && end.isValid && progress.isValid
            }
            .eraseToAnyPublisher()
    }

    private var autofillableFieldsPublisher: AnyPublisher<[PageField], Never> {
        sectionValidationPublisher
            .map { (start, end, progress) in
                if start.isValid {
                    if (end.isValid && progress.notFilled) {
                        return [.progress]
                    } else if (end.notFilled && progress.isValid) {
                        return [.end]
                    }
                } else if start.notFilled {
                    if (end.notFilled && progress.isValid) {
                        return [.start, .end]
                    }
                    if (start.notFilled && end.isValid && progress.notFilled) {
                        return [.start, .progress]
                    }
                }
                return []
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    // TODO: Should be smartly using last reading session page instead of 1
    // var computedStart: String {
    //     endIsValid ? String(1) :
    //         progressIsValid ? String(1) : ""
    // }
    // var computedEnd: String {
    //     startIsValid && progressIsValid ? String(start + progress) : ""
    // }
    // var computedProgress: String {
    //     startIsValid && endIsAfterStart ? String(end - start) : ""
    // }
}
