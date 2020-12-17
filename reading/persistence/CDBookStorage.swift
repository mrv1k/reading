//
//  CDBookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-12-15.
//  Copyright © 2020 mrv1k. All rights reserved.
//  inspired by: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
//

import Combine
import CoreData
import Foundation

class CDBookStorage: NSObject, ObservableObject {
    @Published var cdBooks = [Book]()
    private let controller: NSFetchedResultsController<Book>

    @Published var sort = CDBookSort.restored
    @Published var sortSelection = CDBookSort.restored.selection {
        didSet { oldSortSelectionPublisher.send(oldValue) }
    }
    private let oldSortSelectionPublisher = CurrentValueSubject<CDBookSort.Selection, Never>(CDBookSort.restored.selection)
    private var cancellables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [CDBookSort.restored.descriptor]

        controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        controller.delegate = self
        performFetch()

        convertSelectionToSortChain.assign(to: &$sort)
        sortRefreshFetcher.store(in: &cancellables)
    }

    private func performFetch() {
        do {
            try controller.performFetch()
            cdBooks = controller.fetchedObjects ?? []
        } catch {
            print(#function, "failed")
        }
    }

    private func refreshFetch(sortDescriptor: NSSortDescriptor) {
        controller.fetchRequest.sortDescriptors = [sortDescriptor]
        performFetch()
    }
}

extension CDBookStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book] else { return }
        cdBooks = refetchedBooks
    }
}

extension CDBookStorage {
    enum SortAction {
        case toggleDirection
        case change(CDBookSort.Selection)
    }

    private var convertSelectionToSortChain: AnyPublisher<CDBookSort.Sort, Never> {
        oldSortSelectionPublisher.zip($sortSelection)
            .dropFirst()
            .map { (old, new) -> SortAction in old == new ? .toggleDirection : .change(new) }
            .combineLatest($sort)
            .map { (action, sort) -> CDBookSort.Sort in
                switch action {
                case .toggleDirection:
                    let reversed = !sort.isAscending
                    return CDBookSort.factory.create(selection: sort.selection, ascending: reversed)
                case .change(let new):
                    return CDBookSort.factory.create(selection: new)
                }
            }
            .eraseToAnyPublisher()
    }

    private var sortRefreshFetcher: AnyCancellable {
        $sort
            .dropFirst()
            .map(\.descriptor)
            .receive(on: RunLoop.main)
            .sink(receiveValue: refreshFetch(sortDescriptor:))
    }
}
