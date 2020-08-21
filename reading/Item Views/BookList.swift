import SwiftUI
import Foundation
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc

    // TODO: make last selected sort persistent
    @State private var sortDescriptor: NSSortDescriptor = Book.sortByAuthors

    var body: some View {
        NavigationView {
            List {
                BookSortMenu(initialSortDescriptor: $sortDescriptor)
                BookListSorted(sortDescriptor: sortDescriptor)

                HStack {
                    Button(action: {
                        try! self.moc.saveOnChanges()
                    }) {
                        Text("Save")
                    }
                    .buttonStyle(BorderlessButtonStyle())

                    Button(action: {
                        SeedData.shared.deleteBookList()
                    }, label: {
                        Text("DeleteAll")
                    }).buttonStyle(BorderlessButtonStyle())
                }
            }
            .onDisappear {
                do {
                    print("try self.moc.save()")
                    try self.moc.saveOnChanges()
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
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        SeedData.shared.makeBookList(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, moc)
    }
}
