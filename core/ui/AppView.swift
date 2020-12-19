//
//  AppView.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-19.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

@main
struct AppView: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                SummaryTab()
                    .tabItem { Label("Summary", systemImage: "scroll") }

                LibraryTab()
                    .tabItem { Label("Library", systemImage: "books.vertical") }
            }
        }
    }
}
