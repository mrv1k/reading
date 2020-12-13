//
//  AppView.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-24.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import SwiftUI

@main
struct AppView: App {
    @Environment(\.scenePhase) private var scenePhase

    let persistenceController: PersistenceController
    @ObservedObject var settings = AppSettingsEditorViewModel.singleton

    @StateObject var unitOfWork: UnitOfWork

    init() {
        persistenceController = PersistenceController.preview
        let viewContext = persistenceController.container.viewContext
        _unitOfWork = StateObject(wrappedValue: UnitOfWork(context: viewContext))
    }

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { BookList(books: unitOfWork.domainBooks) }
                    .tabItem { Label("Library", systemImage: "books.vertical") }
                    .environmentObject(settings)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(unitOfWork)

                NavigationView {
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Favorites").font(.title2).bold()
                                Spacer()
                            }
                            GroupBox(
                                label: Label("Heart Rate", systemImage: "heart.fill")
                                    .foregroundColor(.red)
                                    .padding(.bottom)
                            ) {
                                HStack {
                                    Text("Your hear rate is 90 BPM.")
                                    Spacer()
                                }
                            }

                            GroupBox(
                                label: Label("Heart Rate", systemImage: "heart.fill")
                                    .foregroundColor(.red)
                                    .padding(.bottom)
                            ) {
                                HStack {
                                    Text("Your hear rate is 90 BPM.")
                                    Spacer()
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .navigationBarTitle("Active")
                }
                .tabItem { Label("Active", systemImage: "scroll") }

                NavigationView { AppSettingsEditor() }
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
