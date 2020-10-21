import SwiftUI

struct BookRow: View {
    var book: Book
    var displayProgressBar = true

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
            if displayProgressBar {
                BookProgressView(value: book.completionPercent)
            }
        }
        .multilineTextAlignment(.leading)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: BookSeeder.preview.fetch(bookWith: .subtitle))
            .previewLayout(.sizeThatFits)
    }
}
