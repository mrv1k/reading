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
    var fieldsNumericallyValid: Bool { start > 0 && end > start }
    var progress: Int {
        fieldsNumericallyValid ? end - start : 0
    }


    enum InputCombination {
        case none
        case partial
        case all

        case startAndEnd
        case endAndProgress
        case onlyEnd
        case onlyProgress
    }

    var availableUserInput: InputCombination {
        print("isEmpty", startField.isEmpty, endField.isEmpty, progressField.isEmpty)
        print("isNotEmpty", !startField.isEmpty, !endField.isEmpty, !progressField.isEmpty)

        let allEmpty = startField.isEmpty && endField.isEmpty && progressField.isEmpty
        let noneEmpty = startField.isEmpty == false
            && endField.isEmpty == false
            && progressField.isEmpty == false

        if allEmpty {
            return .none
        } else if noneEmpty {
            return .all
        }
        print("passed guard")

        if !startField.isEmpty && !endField.isEmpty && progressField.isEmpty {
            return .startAndEnd
        } else if startField.isEmpty && !endField.isEmpty && !progressField.isEmpty {
            return .endAndProgress
        } else if !progressField.isEmpty {
            return .onlyProgress
        } else if !endField.isEmpty {
            return .onlyEnd
        }

        return .partial
    }

    func actOnUserInput(input: InputCombination) -> Void {
        switch input {
        case .none:
            print("no input")
        case .partial:
            print("partial")
        case .all:
            print("all")
        case .startAndEnd:
            print("start and end")
        case .endAndProgress:
            print("end and progress")
        case .onlyEnd:
            print("only end")
        case .onlyProgress:
            print("only progress")
        }
    }

    var progressFieldComputed: String {
        fieldsNumericallyValid ? String(progress) : ""
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

            Button("test") {
                viewModel.actOnUserInput(input: viewModel.availableUserInput)
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
