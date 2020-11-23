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
            NavigationView {
                BookList()
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button {} label: {
                                VStack {
                                    Image(systemName: "scroll")
                                    Text("Reading Now").font(.caption2).bold()
                                }
                            }
                            Spacer()
                            Button {} label: {
                                VStack {
                                    Image(systemName: "books.vertical")
                                    Text("Library").font(.caption2).bold()
                                }
                            }
                            Spacer()
                            Button {} label: {
                                VStack {
                                    Image(systemName: "gauge")
                                    Text("Statistics").font(.caption2).bold()
                                }
                            }
                            Spacer()
                            Button {} label: {
                                VStack {
                                    Image(systemName: "gearshape")
                                    Text("Settings").font(.caption2).bold()
                                }
                            }
                        }
                    }
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(settings)
            // FIXME: do you really need to pass bookStorage as envObj?
            .environmentObject(bookStorage)
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
