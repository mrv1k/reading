//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

enum InputCombination {
    case startAndEnd, startAndProgress, onlyEnd, onlyProgress

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

class SessionCreatePagesViewModel: ObservableObject {
    @Published var startField = ""
    @Published var endField = ""
    @Published var progressField = ""

    var start: Int { Int(startField) ?? 0 }
    var end: Int { Int(endField) ?? 0 }
    var progress: Int { Int(progressField) ?? 0 }

    var startIsValid: Bool { start > 0 }
    var endIsValid: Bool { end > 0 }
    var endIsAfterStart: Bool { end > start }
    var progressIsValid: Bool { progress > 0 }

    var inputCombination: InputCombination? {
        InputCombination.determine(startIsValid, endIsValid, progressIsValid)
    }

    func autofill() {
        switch inputCombination {
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
            break
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
        startIsValid && endIsAfterStart ? String(end - start) : ""
    }
}

struct AutofillButton: View {
    var autofill: () -> Void
    var inputCombination: InputCombination?
    var displayOn: [InputCombination]

    var visible: Bool {
        inputCombination != nil ?
            displayOn.contains(inputCombination!) : false
    }

    var body: some View {
        if visible {
            Divider()
            Button(action: autofill) {
                Image(systemName: "text.badge.plus")
                    .padding([.leading, .trailing])
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}

struct TextFieldWithAutofill: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel
    var title: String
    var text: Binding<String>
    var displayOn: [InputCombination]

    var body: some View {
        HStack {
            TextField(title, text: text)
                .frame(maxHeight: .infinity)
                .keyboardType(.numberPad)
            AutofillButton(
                autofill: viewModel.autofill,
                inputCombination: viewModel.inputCombination,
                displayOn: displayOn)
        }
    }
}

struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    var body: some View {
        Section(header: Text("Pages")) {
            TextFieldWithAutofill(
                viewModel: viewModel,
                title: "Start",
                text: $viewModel.startField,
                displayOn: [.startAndEnd, .startAndProgress])

            TextFieldWithAutofill(
                viewModel: viewModel,
                title: "End",
                text: $viewModel.endField,
                displayOn: [.onlyEnd, .startAndEnd])

            TextFieldWithAutofill(
                viewModel: viewModel,
                title: "Progress",
                text: $viewModel.progressField,
                displayOn: [.onlyProgress, .startAndProgress])

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
