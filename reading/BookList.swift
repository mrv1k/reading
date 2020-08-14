import SwiftUI
import Foundation
import CoreData

struct BookList: View {
    @Environment(\.managedObjectContext) var moc

    // @FetchRequest(fetchRequest: NSFetchRequest<Book>(entityName: "Book"))
    // @FetchRequest(
    //     entity: Book.entity(),
    //     sortDescriptors: [Book.alphabeticAuthors]
    // ) var books: FetchedResults<Book>

    enum Sort: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case recent, author, title
    }

    var sortsMap = [
        Sort.recent: Book.creationOrder,
        Sort.title: Book.alpahbeticTitle,
        Sort.author: Book.alphabeticAuthors
    ]

    var books: [Book] {
        Book.fetchWithSort(
            moc: moc,
            sort: sortsMap[selectedSort]!
        )
    }

    @State private var selectedSort: Sort = .title
    // TODO: make last sort persistent

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
                    // TODO: figure out when to save
                })

                Picker("Sorting", selection: $selectedSort) {
                    ForEach(Sort.allCases) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

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

        SeedData.shared.makeBookList(seedOnce: true)

        return BookList()
            .environment(\.managedObjectContext, moc)
    }
}
