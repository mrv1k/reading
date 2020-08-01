import SwiftUI

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var isActive
    let book: Book

    var body: some View {
        VStack {
            if book.image != nil {
                Text("image")
                // Image(book.image!)
            }

            Text(book.title)

            if book.subtitle != nil {
                Text(book.subtitle!)
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
        BookDetail(book: SeedData.shared.makeBook(with: .minimum))
            .environment(\.managedObjectContext, SeedData.shared.moc)
    }
}