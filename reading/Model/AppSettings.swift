//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine

protocol AppSettingsProvider {
    static var shared: AppSettings { get set }
}

class AppSettings: ObservableObject, AppSettingsProvider {
    static var shared = AppSettings()

    private init() {}

    // TODO: make persistent
    @Published var progressPercentage = false
    @Published var relativeTime = false
}

protocol AppSettingsConsumer {
    var settings: AppSettings { get }
}

extension AppSettingsConsumer {
    var settings: AppSettings { AppSettings.shared }
}
