//
//  SettingsEditor.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI
import Combine

struct SettingsEditor: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        Form {
            Section(header: Text("Session Row")) {
                Picker("Progress display style", selection: $settings.progressStyle) {
                    ForEach(SessionStyleProgress.allCases, id: \.self) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                Picker("Time display style", selection: $settings.timeStyle) {
                    ForEach(SessionStyleTime.allCases, id: \.self) { style in
                        Text(style.rawValue).tag(style)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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
        .environmentObject(AppSettings.shared)
        .previewDevice("iPhone SE (2nd generation)")
    }
}
