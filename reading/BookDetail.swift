import SwiftUI

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
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
            // Text("by " + book.authors.joined(separator: ", "))

            Text(String(book.pageCount) + " pages")

            Button(action: {
                self.isActive.wrappedValue.dismiss()
            }) {
                Text("Up to BookList")
            }

//            Text("isEbook \(book.isEbook ? "true" : "false")")
        }
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        return BookDetail(book: SeedData.shared.book1())
            .environment(\.managedObjectContext, SeedData.shared.context)
        // Group {
        //     BookDetail(
        //         book: sampleBookWith["everything"]!
        //     )
        //
        //     PreviewWithNavigation(
        //         anyView: AnyView(BookDetail(book: sampleBookWith["everything"]!))
        //     )
        // }
        // .environment(\.managedObjectContext, context)
    }
}
