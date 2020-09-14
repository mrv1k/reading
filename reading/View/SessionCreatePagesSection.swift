//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct AutofillButton: View {
    var autofill: () -> Void
    var inputCombination: SessionCreatePagesViewModel.InputCombination?
    var displayOn: [SessionCreatePagesViewModel.InputCombination]

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
    var displayOn: [SessionCreatePagesViewModel.InputCombination]

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
