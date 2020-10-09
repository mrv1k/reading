//
//  PersistenceController.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-08-24.
//  Copyright © 2020 mrv1k. All rights reserved.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        let bookSeeder = BookSeeder(context: viewContext)
        bookSeeder.insertAllCases()

        let testBook = bookSeeder.fetch(book: .test)

        let session = Session(context: viewContext)
        session.book = testBook
        session.pageStart = 1
        session.pageEnd = 26
        session.progressPage = 25
        session.progressPercent = 5.0
        session.createdAt = Date()

        let session1 = Session(context: viewContext)
        session1.book = testBook
        session1.pageStart = 26
        session1.pageEnd = 51
        session1.progressPage = 25
        session1.progressPercent = 5.0
        session1.createdAt = Date() + 60 * 60


        let session2 = Session(context: viewContext)
        session2.book = bookSeeder.fetch(book: .minimum)
        session2.pageStart = 100
        session2.pageEnd = 300
        session2.progressPage = 200
        session2.progressPercent = 13.5
        session2.createdAt = Date()

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "reading")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
