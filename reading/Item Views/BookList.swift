import SwiftUI
import Foundation

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var sortDescriptor: NSSortDescriptor

    init() {
        if let savedSortDescriptor = UserDefaults.standard.object(forKey: "sortDescriptor") as? Data {
            if let decodedSortDescriptor = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedSortDescriptor) as? NSSortDescriptor {
                self._sortDescriptor = State(initialValue: decodedSortDescriptor)
                return
            }
        }
        self._sortDescriptor = State(initialValue: Book.sortByTitle)
    }

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
