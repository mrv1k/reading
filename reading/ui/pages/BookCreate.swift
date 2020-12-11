import SwiftUI

struct BookCreate: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var isActive

    var repository: DomainBookRepository

    @State private var image: Image?
    @State private var title = "title"
    @State private var subtitle: String?
    @State private var author = "author"
    @State private var pageCount = "100"

    var hasEmptyRequiredField: Bool {
        title.isEmpty || author.isEmpty || pageCount.isEmpty
    }

    var body: some View {
        Form {
            Section(header: Text("INFORMATION")) {
                TextField("Title", text: $title)

                TextField("Author(s)", text: $author)

                TextField("Pages", text: $pageCount)
                    .keyboardType(.numberPad)
            }

            Section {
                Button(action: {
                    let domainBook = DomainBook(title: title, author: author, pageCount: Int(pageCount)!)
                    repository.create(domainBook: domainBook)

                    self.isActive.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }
            }
            .disabled(hasEmptyRequiredField)
        }
        .navigationBarTitle("Add a book", displayMode: .inline)
    }
}

//struct BookCreate_Previews: PreviewProvider {
//    static var previews: some View {
//        BookCreate()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
