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

class BookStorage: NSObject, ObservableObject {
    @Published var books: [Book] = []
    @Published var sort: BookSort

    private let booksController: NSFetchedResultsController<Book>
    private var refreshFetcher: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {

        let savedSort = UserDefaults.standard.string(forKey: UserKeys.bookSort.key)
        // Has to use BookSort.init(rawValue:) or IDE wants to both add and remove force unwrap
        let sort = (savedSort != nil) ? BookSort.init(rawValue: savedSort!)! : BookSort.title

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [sort.descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        self.sort = sort
        super.init()

        booksController.delegate = self
        performFetch()

        refreshFetcher = $sort.sink(receiveValue: { newSort in
            guard self.sort != newSort else { return }
            self.refreshFetchWith(descriptor: newSort.descriptor)
            UserDefaults.standard.set(newSort.rawValue, forKey: UserKeys.bookSort.key)
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
    case title = "Title"
    case author = "Author"
    case createdAt = "Date"

    var id: String { rawValue }

    var descriptor: NSSortDescriptor {
        switch self {
        case .title: return byTitle
        case .author: return byAuthor
        case .createdAt: return byCreatedAt
        }
    }

    var byTitle: NSSortDescriptor {
        return NSSortDescriptor(
            key: #keyPath(Book.title),
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }

    var byCreatedAt: NSSortDescriptor {
        return NSSortDescriptor(keyPath: \Book.createdAt, ascending: true)
    }

    var byAuthor: NSSortDescriptor {
        return NSSortDescriptor(
            key: #keyPath(Book.author),
            ascending: true,
            selector: #selector(NSString.localizedStandardCompare(_:))
        )
    }

}
