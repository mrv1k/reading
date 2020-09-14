//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField = ""
    @Published var endField = ""
    @Published var progressField = ""

    var start: Int { Int(startField) ?? 0 }
    var end: Int { Int(endField) ?? 0 }
    var progress: Int { Int(progressField) ?? 0 }

    var startIsValid: Bool { start > 0 }
    var endIsValid: Bool { end > start }
    var progressIsValid: Bool { progress > 0 }

    enum InputCombination {
        case startAndEnd, startAndProgress, onlyEnd, onlyProgress
        // case for ignored combinations such as: all, partial, none
        case ignored
    }

    func determineCombination() -> InputCombination {
        let hasStart = !startField.isEmpty
        let hasEnd = !endField.isEmpty
        let hasProgress = !progressField.isEmpty

        switch (hasStart, hasEnd, hasProgress) {
        case (false, hasEnd, false):
            return .onlyEnd
        case (false, false, hasProgress):
            return .onlyProgress
        case (hasStart, hasEnd, false):
            return .startAndEnd
        case (hasStart, false, hasProgress):
            return .startAndProgress
        default:
            return .ignored
        }
    }

    func attempAutofill() {
        switch determineCombination() {
        case .startAndEnd:
            progressField = computedProgress
        case .startAndProgress:
            endField = computedEnd
        case .onlyEnd:
            startField = computedStart
            progressField = computedProgress
        case .onlyProgress:
            startField = computedStart
            endField = computedEnd
        default:
            print("all / none / partial - no automation")
        }
    }

    // TODO: Should be smartly using last reading session page instead of 1
    var computedStart: String {
        endIsValid ? String(1) :
            progressIsValid ? String(1) : ""
    }
    var computedEnd: String {
        startIsValid && progressIsValid ? String(start + progress) : ""
    }
    var computedProgress: String {
        startIsValid && endIsValid ? String(end - start) : ""
    }
}


struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    var body: some View {
        Section(header: Text("Pages")) {
            TextField("Start", text: $viewModel.startField)
                .keyboardType(.numberPad)

            TextField("End", text: $viewModel.endField)
                .keyboardType(.numberPad)

            TextField("Read", text: $viewModel.progressField)
                .keyboardType(.numberPad)

            Button("Autofill") {
                viewModel.attempAutofill()
            }
            Button("Reset") {
                viewModel.startField = ""
                viewModel.endField = ""
                viewModel.progressField = ""
            }
        }
    }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SessionCreatePagesSection(viewModel: SessionCreatePagesViewModel())
        }
    }
}
