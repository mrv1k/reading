//
//  SettingsEditor.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI
import Combine

// TODO: make persistent
class AppSettings: ObservableObject {
    @Published var progressStyle = SessionStyleProgress.page
    @Published var timeStyle = SessionStyleTime.time

    // var progressProxy: SessionStyleProgress {
    //     get { progressStyle[0] }
    //     set { progressStyle[0] = newValue }
    // }
    //
    // var timeProxy: SessionStyleTime {
    //     get { timeStyle[0] }
    //     set { timeStyle[0] = newValue }
    // }
}

class SettingsEditorViewModel: ObservableObject {

}

enum SessionStyleProgress: String, CaseIterable {
    case page
    case percent
}

enum SessionStyleTime: String, CaseIterable {
    case time
    case relative

    var type: Text.DateStyle {
        switch self {
        case .time: return Text.DateStyle.time
        case .relative: return Text.DateStyle.relative
        }
    }
}

struct SettingsEditor: View {
    @Environment(\.editMode) private var editMode
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        List {
            VStack(alignment: .leading) {
                HStack {
                    Picker("Page progress style", selection: $settings.progressStyle) {
                        ForEach(SessionStyleProgress.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Spacer()

                    Picker("Page progress style", selection: $settings.timeStyle) {
                        ForEach(SessionStyleTime.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

struct SettingsEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                SettingsEditor()
            }
        }
        .environment(\.editMode, Binding.constant(EditMode.active))
        .previewDevice("iPhone SE (2nd generation)")
    }
}
