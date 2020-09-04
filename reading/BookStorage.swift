//
//  BookStorage.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-09-02.
//  Copyright © 2020 mrv1k. All rights reserved.
//  inspired by: https://www.donnywals.com/fetching-objects-from-core-data-in-a-swiftui-proje
//

import Foundation
import Combine
import CoreData

fileprivate let bookSortKey = "BookSort"

class BookStorage: NSObject, ObservableObject {
    @Published var books: [Book] = []
    @Published var sort: BookSort

    private let booksController: NSFetchedResultsController<Book>
    private var refreshFetcher: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()

        let savedSortRawValue = UserDefaults.standard.string(forKey: bookSortKey) ?? "title"
        let bookSort = BookSort.init(rawValue: savedSortRawValue)!
        sort = bookSort
        let descriptor = bookSort.descriptor()
        fetchRequest.sortDescriptors = [descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        booksController.delegate = self
        performFetch()

        refreshFetcher = $sort.sink(receiveValue: { newSort in
            guard self.sort != newSort else { return }
            self.refreshFetchWith(descriptor: newSort.descriptor())
            UserDefaults.standard.set(newSort.rawValue, forKey: bookSortKey)
        })
    }

    private func performFetch() {
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
        } catch {
            print(#function, "failed")
        }
    }

    private func refreshFetchWith(descriptor: NSSortDescriptor) {
        booksController.fetchRequest.sortDescriptors = [descriptor]
        performFetch()
    }
}

extension BookStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book]
        else { return }
        books = refetchedBooks
    }
}

enum BookSort: String, CaseIterable, Identifiable {
    case title, author, date
    var id: String { rawValue }

    func descriptor() -> NSSortDescriptor {
        switch self {
        case .title: return Book.sortByTitle
        case .author: return Book.sortByAuthors
        case .date: return Book.sortByCreationDate
        }
    }
}
