import SwiftUI
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Book.entity(),
        sortDescriptors: Book.defaultSortDescriptors
    ) var books: FetchedResults<Book>

    @State private var selection = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(books) { book in
                    NavigationLink(
                        destination: BookDetail(book: book)
                    ) {
                        BookRow(book: book)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        self.moc.delete(self.books[index])
                    }
                    do {
                        try self.moc.save()
                        print("saved")
                    } catch {
                        print("couldnt save after delete")
                    }
                    // TODO: figure out how & when to save after delete without a button
                })


                Picker(selection: $selection, label:
                    Text("Sort by"),
                    content: {
                        Text("Recent").tag(0)
                        Text("Title").tag(1)
                        Text("Author").tag(2)
                }).pickerStyle(SegmentedPickerStyle())

                HStack {
                    Button(action: {
                        try! self.moc.save()
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
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink(destination: BookCreate()) { Text("Add") })
            .navigationBarTitle("Books", displayMode: .inline)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let _ = SeedData.shared.makeBookList(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, moc)
    }
}
