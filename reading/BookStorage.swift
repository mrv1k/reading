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
    private var descriptor: NSSortDescriptor
    private var refreshFetcher: AnyCancellable?

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()

        let descriptor = loadSavedDescriptor() ?? Book.sortByTitle
        self.descriptor = descriptor
        sort = BookSort.generate(from: descriptor)
        fetchRequest.sortDescriptors = [descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        booksController.delegate = self
        performFetch()

        refreshFetcher = $sort.sink(receiveValue: { newSort in
            print("sink before guard")
            guard self.sort != newSort else { return }
            print("sink after guard")

            self.refreshFetchWith(descriptor: newSort.descriptor())
        })
    }

    func performFetch() {
        do {
            try booksController.performFetch()
            books = booksController.fetchedObjects ?? []
        } catch {
            print("failed to fetch books")
        }
    }

    func refreshFetchWith(descriptor: NSSortDescriptor) {
        booksController.fetchRequest.sortDescriptors = [descriptor]
        performFetch()
        saveDescriptor(descriptor)
    }
}

extension BookStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let refetchedBooks = controller.fetchedObjects as? [Book]
        else { return }
        books = refetchedBooks
    }
}

fileprivate func saveDescriptor(_ descriptor: NSSortDescriptor) {
    do {
        let savedData = try NSKeyedArchiver.archivedData(
            withRootObject: descriptor,
            requiringSecureCoding: true)
        UserDefaults.standard.setValue(savedData, forKey: "sortDescriptor")
    } catch {
        fatalError("failed to \(#function)")
    }
}

fileprivate func loadSavedDescriptor() -> NSSortDescriptor? {
    if let saved = UserDefaults.standard.object(forKey: "sortDescriptor") as? Data {
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saved) as? NSSortDescriptor {
            return decoded
        }
    }
    return nil
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

    static func generate(from descriptor: NSSortDescriptor) -> BookSort {
        switch descriptor {
        case Book.sortByTitle: return .title
        case Book.sortByAuthors: return .author
        case Book.sortByCreationDate: return .date
        default:
            #if DEBUG
            fatalError("Failed to initialize `initialSort` from `initialSortDescriptor`")
            #else
            return .title
            #endif
        }
    }
}
