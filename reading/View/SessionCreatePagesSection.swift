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

    @State var validationAlert = false

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

            if viewModel.startValidation.count != 0 {
                VStack {
                    ForEach(viewModel.startValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }
            if viewModel.endValidation.count != 0 {
                VStack {
                    ForEach(viewModel.endValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }
            if viewModel.progressValidation.count != 0 {
                VStack {
                    ForEach(viewModel.progressValidation, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                }
            }

            Button("Reset") {
                viewModel.startField = ""
                viewModel.endField = ""
                viewModel.progressField = ""
            }

            // if !viewModel.validationMessages.isEmpty {
            //     Button("Submit") {
            //         print("invalid submit")
            //         validationAlert = true
            //     }
            //     .alert(isPresented: $validationAlert) {
            //         Alert(title: Text(viewModel.validationMessages.first!))
            //     }
            // } else {
            //     Button("Submit") {
            //         print("valid submit")
            //     }
            // }
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
