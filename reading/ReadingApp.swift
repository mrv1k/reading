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

    let userData: UserData

    init() {
        persistenceController = PersistenceController.shared
        let viewContext = persistenceController.container.viewContext

        userData = UserData()

        let storage = BookStorage(viewContext: viewContext, sort: userData.sortDescriptor)
        _bookStorage = StateObject(wrappedValue: storage)
    }

    var body: some Scene {
        WindowGroup {
            NavigationView {
                BookList(bookStorage: bookStorage)
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environmentObject(userData)
            .onChange(of: scenePhase, perform: backgroundSave)
        }
    }

    // #BETA5: onChange should work on Scene, but doesn't; attach to View for now.
    private func backgroundSave(_ phase: ScenePhase) {
        if phase == .background {
            do {
                try persistenceController.container.viewContext.saveOnChanges()
                print("\(#function): saved")
            } catch {
                print("onChange: failed to save on .inactive case")
            }
        }

    }
}
