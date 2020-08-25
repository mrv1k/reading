import SwiftUI
import CoreData

struct BookDetail: View {
    @Environment(\.presentationMode) private var isActive
    let book: Book

    var body: some View {
        VStack {
            // if book.image != nil {
            //     Text("image")
            // }

            HStack {
                Spacer()
                Text(book.title).multilineTextAlignment(.center)
                Spacer()
            }

            Text("by " + book.authors)

            Text(String(book.pageCount) + " pages")

            Button(action: {
                self.isActive.wrappedValue.dismiss()
            }) {
                Text("Up to BookList")
            }
        }
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        let seeder = BookSeeder(moc: viewContext)

        return Group {
            BookDetail(book: seeder.insert(bookWith: .minimum))
            BookDetail(book: seeder.insert(bookWith: .everything))
        }.previewLayout(.sizeThatFits)
    }
}
