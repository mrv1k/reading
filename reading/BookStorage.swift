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
    @Published var sortDescriptor: NSSortDescriptor

    private var refreshFetcher: AnyCancellable?
    private let booksController: NSFetchedResultsController<Book>

    init(viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()

        let descriptor = loadDescriptor() ?? Book.sortByTitle
        sortDescriptor = descriptor
        fetchRequest.sortDescriptors = [descriptor]

        booksController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil, cacheName: nil)

        super.init()

        booksController.delegate = self

        performFetch()

        refreshFetcher = $sortDescriptor.sink(receiveValue: { newDescriptor in
            guard self.sortDescriptor != newDescriptor else { return }
            self.refreshFetchWith(descriptor: newDescriptor)
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

fileprivate func loadDescriptor() -> NSSortDescriptor? {
    if let saved = UserDefaults.standard.object(forKey: "sortDescriptor") as? Data {
        if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(saved) as? NSSortDescriptor {
            return decoded
        }
    }
    return nil
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
