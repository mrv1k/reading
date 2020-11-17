//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

protocol AppSettingsProvider {
    static var singleton: AppSettings { get set }
}

class AppSettings: ObservableObject, AppSettingsProvider {
    static var singleton = AppSettings()

    @Published var progressPercentage: Bool
    @Published var relativeTime: Bool
    private var cancellables = Set<AnyCancellable>()

    private init() {
        progressPercentage = UserDefaults.standard.bool(forKey: UserDefaultsKey.progressPercentage.rawValue)
        relativeTime = UserDefaults.standard.bool(forKey: UserDefaultsKey.relativeTime.rawValue)

        subscribeToSaveInUserDefaults(publisher: $progressPercentage, key: .progressPercentage)
        subscribeToSaveInUserDefaults(publisher: $relativeTime, key: .relativeTime)
    }

    func subscribeToSaveInUserDefaults<T>(publisher: Published<T>.Publisher, key: UserDefaultsKey) {
        publisher
            .dropFirst()
            .sink { UserDefaults.standard.set($0, forKey: key.rawValue) }
            .store(in: &cancellables)
    }
}

protocol AppSettingsConsumer {
    var settings: AppSettings { get }
}

extension AppSettingsConsumer {
    var settings: AppSettings { AppSettings.singleton }
}
