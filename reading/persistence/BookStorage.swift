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
            .map { cdBooks in cdBooks.map { cdBook in cdBook.toDomainModel() } }
            .assign(to: &$domainBooks)
    }
}

class CDBookControllerContainer: NSObject, ObservableObject {
    @Published var cdBooks = [Book]()

    @Published var sort = CDBookSort.loadedSort
    @Published var sortSelection = CDBookSort.loadedSelection {
        didSet { oldSortSelectionPublisher.send(oldValue) }
    }

    private let controller: NSFetchedResultsController<Book>
    private let oldSortSelectionPublisher = PassthroughSubject<CDBookSort.Selection, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [CDBookSort.loadedSort.descriptor]

        controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)
        super.init()

        controller.delegate = self
        performFetch()

        determineSortActionChain.assign(to: &$sort)
        syncUI.store(in: &cancellables)
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

extension CDBookControllerContainer {
    enum SortAction {
        case toggleDirection(CDBookSort.Selection)
        case change(CDBookSort.Selection)
    }

    var determineSortActionChain: AnyPublisher<CDBookSort.Sort, Never> {
        oldSortSelectionPublisher
            .zip($sortSelection)
            .drop(untilOutputFrom: oldSortSelectionPublisher)
            .map { (old, new) -> SortAction in old == new ? .toggleDirection(old) : .change(new) }
            .combineLatest($sort)
            .map { (action, sort) -> CDBookSort.Sort in
                switch action {
                case .toggleDirection(let old):
                    let reversed = !sort.isAscending
                    return CDBookSort.factory.create(selection: old, ascending: reversed)
                case .change(let new):
                    return CDBookSort.factory.create(selection: new)
                }
            }
            .eraseToAnyPublisher()
    }

    var syncUI: AnyCancellable {
        $sort
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] sort in
                self?.refreshFetch(sortDescriptor: sort.descriptor)
            })
    }
}
