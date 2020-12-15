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

    @Published var sortSelection = initalSort.selection {
        didSet { oldSortSelectionPublisher.send(oldValue) }
    }

    let oldSortSelectionPublisher = PassthroughSubject<BookSortSelection, Never>()

    var sortImage: String = initalSort.directionImage
    @Published private var sort: BookSort = initalSort

    private let controller: NSFetchedResultsController<Book>
    private var cancellables = Set<AnyCancellable>()

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [Self.initalSort.descriptor]

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
        case toggleDirection
        case change(BookSortSelection)
    }

    var determineSortActionChain: AnyPublisher<BookSort, Never> {
        oldSortSelectionPublisher
            .zip($sortSelection)
            .drop(untilOutputFrom: oldSortSelectionPublisher)
            .map { (old, new) -> SortAction in old == new ? .toggleDirection : .change(new) }
            .combineLatest($sort)
            .map { (action, sort) -> BookSort in
                switch action {
                case .toggleDirection:
                    var copy = sort
                    // FIXME: make ascending var private
                    copy.isAscending.toggle()
                    return copy
                case .change(let selection):
                    return BookSortFactory.create(selection: selection)
                }
            }
            .eraseToAnyPublisher()
    }

    var syncUI: AnyCancellable {
        $sort
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] sort in
                self?.sortImage = sort.directionImage
                self?.refreshFetch(sortDescriptor: sort.descriptor)
            })
    }
}
