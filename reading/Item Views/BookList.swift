import SwiftUI
import Foundation

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext

    // TODO: make last selected sort persistent
    @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

    var body: some View {
        NavigationView {
            List {
                // TODO: Animate sort transition
                BookListSorted(sortDescriptor: sortDescriptor)
            }
            .animation(.default)

            .onDisappear {
                do {
                    try self.viewContext.saveOnChanges()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            .navigationBarItems(
                trailing: Menu {
                    NavigationLink(destination: BookCreate()) {
                        Label("New Book", systemImage: "plus")
                    }
                    Divider()
                    BookListSortMenu(initialSortDescriptor: $sortDescriptor)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }

            )
            .navigationBarTitle("Books", displayMode: .inline)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        BookSeeder(context: viewContext).insertAllCases(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, viewContext)
    }
}
