//
//  SessionCreatePagesViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-14.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    var startViewModel = SessionCreatePageViewModel()
    var endViewModel = SessionCreatePageViewModel()
    var progressViewModel = SessionCreatePageViewModel()

    @Published var missingFields = [PageField]()

    // @Published var sectionValidaton = ""
    @Published var sectionIsValid = false

    // private var cancellableSet: Set<AnyCancellable> = []

    init() {
        missingFieldsPublisher.assign(to: &$missingFields)
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

    private var missingFieldsPublisher: AnyPublisher<[PageField], Never> {
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
                    if (end.isValid && progress.notFilled) {
                        return [.start, .progress]
                    }
                }
                return []
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }


    func autofill() {
        let start = startViewModel.page
        let end = endViewModel.page
        let progress = progressViewModel.page

        // progressViewModel.$input.share()
        // progressViewModel.debouncedInput.share()
        switch missingFields {
        case [.progress]:
            progressViewModel.input = String(end! - start!)
        case [.end]:
            endViewModel.input = String(start! + progress!)

        // TODO: Pull latest read page
        case [.start, .end]:
            let localStart = 1
            startViewModel.input = String(localStart)
            endViewModel.input = String(localStart + progress!)
        case [.start, .progress]:
            let localStart = 1
            startViewModel.input = String(localStart)
            progressViewModel.input = String(localStart + end!)
        default:
            break
        }
    }
}

enum PageField: String {
    case start, end, progress
}
