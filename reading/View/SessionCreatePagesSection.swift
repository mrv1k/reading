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
                PageTextField(placeholder: "Start page", text: $viewModel.startField)
                PageAutofillButton(canBeAutofilled: viewModel.canBeAutofilled(field: .start)) {
                    viewModel.autofill(field: .start)
                }
            }

            HStack {
                PageTextField(placeholder: "End page", text: $viewModel.endField)
                PageAutofillButton(canBeAutofilled: viewModel.canBeAutofilled(field: .end)) {
                    viewModel.autofill(field: .end)
                }
            }

            HStack {
                PageTextField(placeholder: "Progress", text: $viewModel.progressField)
                PageAutofillButton(canBeAutofilled: viewModel.canBeAutofilled(field: .progress)) {
                    viewModel.autofill(field: .progress)
                }
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
    var canBeAutofilled: Bool
    var autofill: () -> Void

    var body: some View {
        if canBeAutofilled {
            Divider()
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
