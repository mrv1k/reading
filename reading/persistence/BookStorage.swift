//
//  BookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//  inspired by: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-project/
//

import Combine
import CoreData
import Foundation

class UnitOfWork: ObservableObject {
    let repository: DomainBookRepository
    var cdBookController: CDBookControllerContainer
    @Published var domainBooks = [DomainBook]()

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        repository = DomainBookRepository(context: context)
        cdBookController = CDBookControllerContainer(viewContext: context)

        cdBookController.$cdBooks
            .map { (cdBooks: [Book]) in
                cdBooks.map { $0.toDomainModel() }
            }
            .assign(to: &$domainBooks)
    }
}

class CDBookControllerContainer: NSObject, ObservableObject {
    @Published var cdBooks = [Book]()

    @Published var sortSelection: BookSortSelection
    var sortImage: String
    private var sort: BookSort

    private let controller: NSFetchedResultsController<Book>
    private var _sortMenuSelectionHandler: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {
        let initialSort = createInitialBookSort()
        sort = initialSort
        sortSelection = initialSort.selection
        sortImage = initialSort.directionImage

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [initialSort.descriptor]

        controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        controller.delegate = self
        performFetch()

        _sortMenuSelectionHandler = sortMenuSelectionHandler
    }

    private var sortMenuSelectionHandler: AnyCancellable {
        $sortSelection
            .dropFirst()
            .compactMap { [weak self] newSelection -> BookSort? in
                guard let self = self else { return nil }
                let oldSelection = self.sortSelection
                // if new and old match, toggle sort direction
                if newSelection == oldSelection {
                    self.sort.isAscending.toggle()
                } else {
                    self.sort = BookSortFactory.create(selection: newSelection)
                }
                return self.sort
            }
            .sink(receiveValue: refreshFetch(sort:))
    }

    private func performFetch() {
        do {
            try controller.performFetch()
            cdBooks = controller.fetchedObjects ?? []
        } catch {
            print(#function, "failed")
        }
    }

    private func refreshFetch(sort: BookSort) {
        sortImage = sort.directionImage
        controller.fetchRequest.sortDescriptors = [sort.descriptor]
        performFetch()
    }
}

extension CDBookControllerContainer: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book] else { return }
        cdBooks = refetchedBooks
    }
}

private func createInitialBookSort() -> BookSort {
    let selection = loadSavedSortSelection() ?? .title
    return BookSortFactory.create(selection: selection)
}

private func loadSavedSortSelection() -> BookSortSelection? {
    if let savedSort = UserDefaults.standard.string(forKey: UserDefaultsKey.bookSort.rawValue) {
        return BookSortSelection(rawValue: savedSort)
    }
    return nil
}
