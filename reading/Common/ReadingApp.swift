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
        persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext

        let storage = BookStorage(viewContext: viewContext)
        _bookStorage = StateObject(wrappedValue: storage)
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    BookList()
                }
                .tabItem { Label("Library", systemImage: "books.vertical") }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(settings)
                // FIXME: do you really need to pass bookStorage as envObj?
                .environmentObject(bookStorage)

                NavigationView {
                    Text("Reading Now").navigationBarTitle("Reading Now")
                }
                .tabItem { Label("Reading Now", systemImage: "scroll") }

//                NavigationView {
//                    Text("Statistics").navigationBarTitle("Statistics")
//                }
//                .tabItem { Label("Statistics", systemImage: "gauge") }

                NavigationView {
                    Text("Settings").navigationBarTitle("Settings")
                }
                .tabItem { Label("Settings", systemImage: "gearshape") }
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
