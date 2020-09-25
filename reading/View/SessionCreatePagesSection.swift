//
//  SessionCreatePagesSection.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

struct SessionCreatePagesSection: View {
    @ObservedObject var sectionViewModel: SessionCreatePagesViewModel
    @State fileprivate var alert: ValidationAlert?

    var body: some View {
        Section(header: Text("Page Section")) {
            SessionCreatePageField(
                fieldViewModel: sectionViewModel.startViewModel,
                placeholder: "Start")

            SessionCreatePageField(
                fieldViewModel: sectionViewModel.endViewModel,
                placeholder: "End")

            SessionCreatePageField(
                fieldViewModel: sectionViewModel.progressViewModel,
                placeholder: "Progress")

            Button("Alert") {
                if sectionViewModel.sectionIsValid {
                    print("submit")
                } else {
                    alert = ValidationAlert(autofillableFields: sectionViewModel.missingFields)
                }
            }
            .alert(item: $alert, content: makeAlertView)

            Button("reset") {
                sectionViewModel.startViewModel.input = ""
                sectionViewModel.endViewModel.input = ""
                sectionViewModel.progressViewModel.input = ""
            }
        }
    }

    fileprivate func makeAlertView(_ alert: ValidationAlert) -> Alert {
        alert.autofillableFields.isEmpty ? alertView(alert: alert) : alertAutofillView(alert: alert)
    }

    fileprivate func alertAutofillView(alert: ValidationAlert) -> Alert {
        let title = "\(alert.subject.capitalized) missing"
        let message = "\(alert.fields) \(alert.subject) \(alert.verb) missing. Do you want to autofill?"

        return Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .cancel(),
            secondaryButton: .default(Text("OK"), action: sectionViewModel.autofill)
        )
    }

    fileprivate func alertView(alert: ValidationAlert) -> Alert {
        // TODO: better alert when no autofill is available
        return Alert(title: Text("Booom, all or some pages invalid"))
    }
}

fileprivate struct ValidationAlert: Identifiable {
    let autofillableFields: [PageField]

    var id: String { fields }
    var fields: String {
        if autofillableFields.isEmpty { return "Some" }

        let string = autofillableFields
            .map { $0.rawValue }
            .joined(separator: " and ")

        return string.prefix(1).capitalized + string.dropFirst()
    }

    private var plural: Bool { autofillableFields.count > 1 }
    var subject: String { plural ? "pages" : "page" }
    var verb: String { plural ? "are" : "is" }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SessionCreatePagesSection(sectionViewModel: SessionCreatePagesViewModel())
        }
    }
}
