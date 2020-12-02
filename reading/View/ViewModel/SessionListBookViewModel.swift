//
//  SessionListBookViewModel.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-08.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import Combine
import CoreData
import SwiftUI

class SessionListBookViewModel: ViewModel, AppSettingsObserver {
    var settings: AppSettings { AppSettings.singleton }

    @Published var editMode = EditMode.inactive // default value only to use self
    typealias SectionElement = Dictionary<String, [SessionRowViewModel]>.Element
    @Published var sections = [SectionElement]()

    var viewContext: NSManagedObjectContext
    @Published var newSession: Session?

    private var cancellables = Set<AnyCancellable>()

    init(
        viewContext: NSManagedObjectContext,
        sessions: [Session],
        editModePublisher: Published<EditMode>.Publisher
    ) {
        self.viewContext = viewContext
        editModePublisher.assign(to: &$editMode)

        sections =
            organizeInDictionary(sessions, by: settings.sessionsIsSortingByNewest)
                .mapValues(transformToViewModels(sessions:))
                .sorted(by: settings.sessionsIsSortingByNewest ? sortByNewest : sortByOldest)

        settings.$sessionsIsSortingByNewest
            .dropFirst()
            .sink { [weak self] isSortingByNewest in
                guard let self = self else { return }
                self.sections.sort(by: isSortingByNewest ? self.sortByNewest : self.sortByOldest)
            }
            .store(in: &cancellables)

        // FIXME: restore UI update when new session is added
//        $editMode
//            .dropFirst()
//            .sink { editMode in
//                if editMode == .active {
        ////                    let dateKey = "Today"
//                    newSession = Session(context: context)
//                    let placeholder = SessionRowViewModel(
//                        createdAt: Date(),
//                        progressPage: 1,
//                        raw_progressPercent: 10
//                    )
//
//                    if self.settings.sessionsIsSortingByNewest {
//                        var section = self.sections.first!.value
//                        section.insert(placeholder, at: 0)
//                        self.sections[0].value = section
//                    }
//                    else {
//                        var section = self.sections.last!.value
//                        section.append(placeholder)
//                        self.sections[self.sections.count - 1].value = section
//                    }
//                }
//            }
//            .store(in: &cancellables)
    }

//    func setPlaceholder<T>(page: T) {
//        pageEndPlaceholder = "Currently on page \(page)"
//    }
}

private extension SessionListBookViewModel {
    func makeDateKey(from date: Date) -> String {
        let isToday = Calendar.current.isDateInToday(date)
        return isToday ? "Today" : Helpers.dateFormatters.date.string(from: date)
    }

    func organizeInDictionary(
        _ sessions: [Session],
        by isSortingByNewest: Bool
    ) -> [String: [Session]] {
        sessions.reduce(into: [:]) { (result: inout [String: [Session]], session: Session) in
            let dateKey = makeDateKey(from: session.createdAt)

            // if key is empty, initialize it to session array
            guard result[dateKey] != nil else { return result[dateKey] = [session] }

            var section = result[dateKey]!
            isSortingByNewest ? section.insert(session, at: 0) : section.append(session)
            result[dateKey]! = section
        }
    }

    func transformToViewModels(sessions: [Session]) -> [SessionRowViewModel] {
        sessions.map { (session: Session) -> SessionRowViewModel in
            SessionRowViewModel(session: session)
        }
    }
}

private extension SessionListBookViewModel {
    func sortByNewest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.session.createdAt > b.value.first!.session.createdAt
    }

    func sortByOldest(a: SectionElement, b: SectionElement) -> Bool {
        a.value.first!.session.createdAt < b.value.first!.session.createdAt
    }
}
