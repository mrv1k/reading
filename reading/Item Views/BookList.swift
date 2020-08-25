import SwiftUI
import Foundation
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var viewContext

    // TODO: make last selected sort persistent
    @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

    var body: some View {
        NavigationView {
            List {
                BookListSortMenu(initialSortDescriptor: $sortDescriptor)
                BookListSorted(sortDescriptor: sortDescriptor)

                HStack {
                    Button(action: {
                        try! self.viewContext.saveOnChanges()
                    }) {
                        Text("Save")
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button(action: {
                        // TODO: Do something with it
                        BookSeeder(context: self.viewContext).deleteAll()
                    }, label: {
                        Text("DeleteAll")
                    }).buttonStyle(BorderlessButtonStyle())
                }
            }
            .onDisappear {
                do {
                    try self.viewContext.saveOnChanges()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: BookCreate()) {
                     Image(systemName: "plus")
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
