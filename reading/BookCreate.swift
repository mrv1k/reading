import SwiftUI

struct BookCreate: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) private var isActive

    @State private var image: Image?
    @State private var title = ""
    @State private var subtitle: String?
    @State private var authors = ""
    @State private var pageCount = ""

    var hasEmptyRequiredField: Bool {
        title.isEmpty || authors.isEmpty || pageCount.isEmpty
    }

    var body: some View {
        Form {
            Section(header: Text("COVER")) {
                VStack(alignment: .center) {
                    Divider()
                    BookCover()
                }
            }

            Section(header: Text("INFORMATION")) {
                TextField("Title", text: $title)

                // if subtitle != nil {
                //     Text(subtitle!)
                // }

                TextField("Author(s)", text: $authors)

                TextField("Pages", text: $pageCount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    guard let pageCount = Int16(self.pageCount) else {
                       // pageCountField is invalid
                        return
                    }

                    // var authors = self.authors.components(separatedBy: ", ")
                    // authors = authors.map { $0.trimmingCharacters(in: .whitespaces) }

                    let book = Book(context: self.managedObjectContext)
                    book.id = UUID()
                    book.title = self.title
                    book.authors = self.authors
                    book.pageCount = pageCount

                    do {
                        try self.managedObjectContext.save()
                        print("saved", book)
                    } catch {
                        print(error.localizedDescription)
                    }

                   // add another or
                    self.isActive.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
            
        .disabled(hasEmptyRequiredField)
        }
        .navigationBarTitle("Add a book", displayMode: .inline)
    }
}

struct BookCreate_Previews: PreviewProvider {
    static var previews: some View {
        let context = SeedData.shared.context
        BookCreate()
            .environment(\.managedObjectContext, context)
    }
}
