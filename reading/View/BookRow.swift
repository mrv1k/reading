import SwiftUI
import Combine

struct BookRow: View {
    var book: Book
    var displayProgressBar = true
    @StateObject var viewModel: BookRowViewModel
    var completionPercent: Int { viewModel.completionPercent }
    // var raw_completionPercent: Int { Int(book.raw_completionPercent) }

    init(book: Book, displayProgressBar: Bool = true) {
        self.book = book
        self.displayProgressBar = displayProgressBar
        _viewModel = StateObject(wrappedValue: BookRowViewModel(book: book))
    }

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
            Text(String(completionPercent))
            Text(String(viewModel.completionPercent))
            Text(String(viewModel.raw_completionPercent))
            if displayProgressBar {
                BookProgressView(value: $viewModel.completionPercent)
                ProgressView(value: Double(book.completionPercent), total: 100)
                ProgressView(value: Double(viewModel.completionPercent), total: 100)
            }
            Button("mek") {
                print(book.raw_completionPercent)
                print(book.completionPercent)
                book.objectWillChange.send()
                print(book.raw_completionPercent)
                print(book.completionPercent)
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
