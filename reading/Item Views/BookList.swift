import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var bookStorage: BookStorage
    var books: [Book] { bookStorage.books }

    @State private var activeLink: String?

    var NavigationLinkProxies: some View {

        let readingSessionCreate = ReadingSessionCreate(
            bookListModal: BookListModal(bookStorage: bookStorage))
        return Group {
            NavigationLink("", destination: BookCreate(), tag: "BookCreate", selection: $activeLink)
            NavigationLink("", destination: readingSessionCreate, tag: "ReadingSessionCreate", selection: $activeLink)
        }
        .hidden()
    }

    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(
                    destination: BookDetail(book: book),
                    label: {
                        BookRow(book: book)
                    })
            }
            .onDelete(perform: deleteBook)
        }
        .animation(.default)
        .navigationBarItems(
            leading: NavigationLinkProxies,
            trailing: Menu {
                Button(action: { activeLink = "BookCreate" },
                       label: { Label("New Book", systemImage: "plus") })
                Button(action: { activeLink = "ReadingSessionCreate" },
                       label: { Label("New Session", systemImage: "plus") })
                Divider()
                BookListSortMenu(bookStorage: bookStorage)
            } label: {
                Image(systemName: "ellipsis.circle")
            }

        )
        .navigationBarTitle("Books", displayMode: .inline)
    }

    func deleteBook(indexSet: IndexSet) {
        withAnimation {
            for index in indexSet {
                viewContext.delete(self.books[index])
            }
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)

        let bookStorage = BookStorage(viewContext: viewContext)
        return NavigationView {
            BookList(bookStorage: bookStorage)
        }.environment(\.managedObjectContext, viewContext)
    }
}
