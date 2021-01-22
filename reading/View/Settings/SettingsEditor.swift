//
//  SettingsEditor.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-09.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import SwiftUI

struct SettingsEditor: View {
    @EnvironmentObject private var settings: AppSettings

    var body: some View {
        List {
            Section(header: Text("Sessions")) {
                Toggle(isOn: $settings.sessionIsInPercents) {
                    Label("Display progress as percentage", systemImage: "percent")
                }

                Toggle(isOn: $settings.sessionsIsSortingByNewest) {
                    Label("Sort sessions from newest to oldest", systemImage: "arrow.up.arrow.down")
                }
            }
        }
        .listStyle(GroupedListStyle())
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
        .environmentObject(AppSettings.singleton)
        .previewDevice("iPhone SE (2nd generation)")
    }
}
