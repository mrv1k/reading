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

    @State var alert: ValidationAlert?

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
                if !sectionViewModel.sectionIsValid {
                    alert = ValidationAlert(
                        // message: "ALL INVALID?",
                        autofillableFields: sectionViewModel.autofillableFields)
                }

            }
            .alert(item: $alert, content: ValidationAlert.makeView) // (_:)?

            Button("reset") {
                sectionViewModel.startViewModel.input = ""
                sectionViewModel.endViewModel.input = ""
                sectionViewModel.progressViewModel.input = ""
            }
        }
    }
}

//
// var noInputAlert: Alert {
//     Alert(title: Text("Page section is empty"),
//           message: Text("At least one page field must be filled"),
//           dismissButton: .some(.cancel()))
// }
// var autofillAlert: Alert {
//     Alert(title: Text("title"),
//           message: Text("possible explanation"),
//           primaryButton: .cancel(),
//           secondaryButton: .destructive(Text("destructive")))
// }

struct ValidationAlert: Identifiable {
    let autofillableFields: [PageField]

    // TODO: only capitalize first field
    var computedFields: String {
        autofillableFields
            .map { $0.rawValue }
            .joined(separator: " and ")
    }

    var id: String { computedFields }

    var plurality: String {
        autofillableFields.count == 1 ? "page" : "pages"
    }

    static func makeView(_ alert: Self) -> Alert {
        let title = "\(alert.computedFields) \(alert.plurality) are missing"
        let message = "Autofill?"

        return Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .cancel(Text("Don't")),
            secondaryButton: .default(Text("OK"), action: {
                print("TODO: autofill")
                // todo: gonna need sectionViewModel access
            })
        )
    }
}

struct SessionCreatePagesSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            SessionCreatePagesSection(sectionViewModel: SessionCreatePagesViewModel())
        }
    }
}
