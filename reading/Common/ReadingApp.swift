//
//  ReadingApp.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-24.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

@main
struct ReadingApp: App {
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController: PersistenceController
    @StateObject var bookStorage: BookStorage
    @ObservedObject var settings = AppSettings.singleton

    init() {
        persistenceController = PersistenceController.preview
        let viewContext = persistenceController.container.viewContext

        _bookStorage = StateObject(wrappedValue: BookStorage(viewContext: viewContext))
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { BookList() }
                    .tabItem { Label("Library", systemImage: "books.vertical") }
                    .environmentObject(settings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    // FIXME: do you really need to pass bookStorage as envObj?
                    .environmentObject(bookStorage)

                NavigationView {
                    Text("Active").navigationBarTitle("Active")
                }
                .tabItem { Label("Active", systemImage: "scroll") }

                NavigationView { SettingsEditor() }
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .environmentObject(settings)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onChange(of: scenePhase, perform: backgroundSave)
    }

    private func backgroundSave(_ phase: ScenePhase) {
        if phase == .background {
            do {
                try persistenceController.container.viewContext.saveOnChanges()
            } catch {
                print("onChange: failed to save on .inactive case")
            }
        }
    }
}
