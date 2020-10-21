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
            ProgressView(value: Double(book.completionPercent), total: 100)
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
