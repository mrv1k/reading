//
//  AppSettings.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-10.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import Foundation

class AppSettings: ViewModel {
    static var singleton = AppSettings()

    @Published var sessionIsInPercents: Bool
    @Published var sessionsIsSortingByNewest: Bool
    private var cancellables = Set<AnyCancellable>()

    private init() {
        sessionIsInPercents = UserDefaults.standard.bool(forKey: UserDefaultsKey.sessionIsInPercents.rawValue)
        sessionsIsSortingByNewest = UserDefaults.standard.bool(forKey: UserDefaultsKey.sessionsIsSortingByNewest.rawValue)

        subscribeToSaveInUserDefaults(publisher: $sessionIsInPercents, key: .sessionIsInPercents)
            .store(in: &cancellables)
        subscribeToSaveInUserDefaults(publisher: $sessionsIsSortingByNewest, key: .sessionsIsSortingByNewest)
            .store(in: &cancellables)
    }

    private func subscribeToSaveInUserDefaults<T>(publisher: Published<T>.Publisher, key: UserDefaultsKey) -> AnyCancellable {
        publisher
            .dropFirst()
            .sink { UserDefaults.standard.set($0, forKey: key.rawValue) }
    }
}
