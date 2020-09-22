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
            .map({ validation in
                validation.rawValue
            })
            .assign(to: &$sectionValidation)

        Publishers.CombineLatest3(
            startViewModel.$validation,
            endViewModel.$validation,
            progressViewModel.$validation)
            .sink { (validation) in
                // var (start, end, progress) = validation
                // print(start.emptyOrPristine, end.emptyOrPristine, progress.emptyOrPristine)
                // PageFieldValidation.emptyOrPristineArr.contains(progress)

                // progress
                switch validation {
                case (.valid, .valid, .pristine):
                    fallthrough
                case (.valid, .valid, .empty):
                    print("progress")

                // start & end
                case (.pristine, .pristine, .valid):
                    fallthrough
                case (.empty, .empty, .valid):
                    fallthrough
                case (.empty, .pristine, .valid):
                    fallthrough
                case (.pristine, .empty, .valid):
                    print("start & end")

                // end
                case (.valid, .pristine, .valid):
                    fallthrough
                case (.valid, .empty, .valid):
                    print("end")

                // start & progress
                case (.empty, .valid, .empty):
                    fallthrough
                case (.pristine, .valid, .pristine):
                    fallthrough
                case (.empty, .valid, .pristine):
                    fallthrough
                case (.pristine, .valid, .empty):
                    print("start & progress")
                default:
                    print("cant autofill")
                }
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
