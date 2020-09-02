import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @ObservedObject var bookStorage: BookStorage

    var body: some View {
        List {
            ForEach (bookStorage.books) { book in
                BookRow(book: book)
            }
            Button {
                bookStorage.performSortedFetch()
            } label: {
                Text("bookStorage.myPerformFetch")
            }

            // BookListSorted(sortDescriptor: userData.sortDescriptor)

            NavigationLink(destination: ReadingSessionCreate()) {
                Label("New Session", systemImage: "plus")
            }
            NavigationLink(destination: BookCreate()) {
                Label("New Book", systemImage: "plus")
            }
        }
        .animation(.default)
        .navigationBarItems(
            trailing: Menu {
                NavigationLink(destination: BookCreate()) {
                    Label("broken: New Book", systemImage: "plus")
                }
                NavigationLink(
                    destination: ReadingSessionCreate(),
                    label: {
                        Label("broken: New Session", systemImage: "plus")
                    })
                Divider()
                BookListSortMenu(initialSortDescriptor: $bookStorage.sortDescriptor)
            } label: {
                Image(systemName: "ellipsis.circle")
            }

        )
        .navigationBarTitle("Books", displayMode: .inline)
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)

        let storage = BookStorage(viewContext: viewContext)
        return BookList(bookStorage: storage)
            .environment(\.managedObjectContext, viewContext)
    }
}
