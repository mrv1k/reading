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
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView { EmptyView() }
                    .tabItem { Label("Library", systemImage: "books.vertical") }

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

                NavigationView { EmptyView() }
                    .tabItem { Label("Settings", systemImage: "gearshape") }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}
