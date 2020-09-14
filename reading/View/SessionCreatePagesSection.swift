//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreatePagesSection: View {
    @ObservedObject var viewModel: SessionCreatePagesViewModel

    var body: some View {
        Section {
            HStack {
                PageTextField(
                    placeholder: "Start page",
                    text: $viewModel.startField)
                PageAutofillButton(
                    combination: viewModel.inputCombination,
                    displayCombinations: [.startAndEnd, .startAndProgress],
                    autofill: viewModel.autofill)
            }

            HStack {
                PageTextField(
                    placeholder: "End page",
                    text: $viewModel.endField)
                PageAutofillButton(
                    combination: viewModel.inputCombination,
                    displayCombinations: [.onlyEnd, .startAndEnd],
                    autofill: viewModel.autofill)
            }

            HStack {
                PageTextField(
                    placeholder: "Progress",
                    text: $viewModel.progressField)
                PageAutofillButton(
                    combination: viewModel.inputCombination,
                    displayCombinations: [.onlyProgress, .startAndProgress],
                    autofill: viewModel.autofill)
            }

            Button("Reset") {
                viewModel.startField = ""
                viewModel.endField = ""
                viewModel.progressField = ""
            }
        }
    }
}

fileprivate struct PageTextField: View {
    var placeholder: String
    var text: Binding<String>

    var body: some View {
        TextField(placeholder, text: text)
            .frame(maxHeight: .infinity)
            .keyboardType(.numberPad)
    }
}

fileprivate struct PageAutofillButton: View {
    var combination: SessionCreatePagesViewModel.InputCombination?
    var displayCombinations: [SessionCreatePagesViewModel.InputCombination]
    var autofill: () -> Void

    var canBeAutofilled: Bool {
        combination != nil ? displayCombinations.contains(combination!) : false
    }

    var body: some View {
        if canBeAutofilled {
            Button(action: autofill) {
                Image(systemName: "text.badge.plus")
                    .padding([.leading, .trailing])
            }
            .buttonStyle(BorderlessButtonStyle())
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
