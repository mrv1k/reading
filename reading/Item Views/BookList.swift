import SwiftUI

struct BookList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var userData: UserData

    var body: some View {
        List {
            BookListSorted(sortDescriptor: userData.sortDescriptor)

            NavigationLink(
                destination: ReadingSessionCreate(),
                label: {
                    Label("New Session", systemImage: "plus")
                })
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
                BookListSortMenu(initialSortDescriptor: $userData.sortDescriptor)
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

        return BookList()
            .environment(\.managedObjectContext, viewContext)
            .environmentObject(UserData())
    }
}
