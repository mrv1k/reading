//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

class SessionCreatePagesViewModel: ObservableObject {
    // setProgressField()
    @Published var startField: String = "" {
        didSet {  }
    }
    // setProgressField()
    @Published var endField: String = "" {
        didSet {  }
    }
    @Published var progressField: String = ""

    var start: Int { Int(startField) ?? 0 }
    var end: Int { Int(endField) ?? 0 }
    var startIsValid: Bool { start > 0 }
    var endIsValid: Bool { end > start }
    var startAndEndAreValid: Bool { startIsValid && endIsValid }
    var progress: Int {
        startAndEndAreValid ? end - start : 0
    }
    var progressIsValid: Bool { progress > 0 }

    enum InputCombination {
        case startAndEnd, endAndProgress, onlyEnd, onlyProgress
        // case for ignored combinations such as: all, partial, none
        case ignored
    }

    var userInputCombination: InputCombination {
        let userInput = (!startField.isEmpty, !endField.isEmpty, !progressField.isEmpty)

        switch userInput {
        case (true, true, false):
            return .startAndEnd
        case (false, true, true):
            return .endAndProgress
        case (false, true, false):
            return .onlyEnd
        case (false, false, true):
            return .onlyProgress
        default:
            return .ignored
        }
    }

    func actOnUserInput(input: InputCombination) -> Void {
        switch input {
        case .startAndEnd:
            print("start and end")
        case .endAndProgress:
            print("end and progress")
        case .onlyEnd:
            print("only end")
        case .onlyProgress:
            print("only progress")
        default:
            print("all / none / partial - no automation")
        }
    }

    var progressFieldComputed: String {
        startAndEndAreValid ? String(progress) : ""
    }
    func setProgressField() {
        progressField = progressFieldComputed
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
                viewModel.actOnUserInput(input: viewModel.userInputCombination)
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
