import SwiftUI

struct BookRow: View {
    var book: Book

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
                .lineLimit(1)
            Text(book.author)
                .font(.subheadline)
                .fontWeight(.light)
            Text("Page count: \(book.pageCount)")
                .font(.footnote)
        }
        .multilineTextAlignment(.leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext

        return Group {
            BookRow(book: BookSeeder(context: viewContext).insert(bookWith: .everything))
                .previewLayout(.sizeThatFits)
        }
    }
}
