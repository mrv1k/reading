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

    @Published var sectionValidation = ""

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        startViewModel.$validation
            .assign(to: &$sectionValidation)

        Publishers.CombineLatest3(
            startViewModel.$validation,
            endViewModel.$validation,
            progressViewModel.$validation)
            .sink { (fieldValidations) in

                var (start, end, progress) = fieldValidations
                print(fieldValidations)
                print(start, end, progress)
            }
            .store(in: &cancellableSet)
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
