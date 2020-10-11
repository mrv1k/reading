import SwiftUI
import CoreData

struct BookDetail: View {
    @Environment(\.presentationMode) private var isActive
    let book: Book

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(book.title).multilineTextAlignment(.center)
                Spacer()
            }

            Text("by " + book.author)

            Text(String(book.pageCount) + " pages")

            NavigationLink("Add a reading session",
                           destination: SessionCreate(book: book))

        }
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            NavigationView {
                BookDetail(book: BookSeeder.preview.fetch(bookWith: .minimum))
            }
            BookDetail(book: BookSeeder.preview.fetch(bookWith: .everything))
                .previewLayout(.sizeThatFits)
        }
    }
}
