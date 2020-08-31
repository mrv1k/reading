import SwiftUI
import Foundation

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var userData: UserData

    var body: some View {
        NavigationView {
            List {
                BookListSorted(sortDescriptor: userData.sortDescriptor)
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
                    BookListSortMenu(initialSortDescriptor: $userData.sortDescriptor)
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
            .environmentObject(UserData())
    }
}
