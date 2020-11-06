import SwiftUI
import CoreData
import Combine

class BookDetailViewModel: ObservableObject {
    var book: Book

    @Published var completionPercent: Double = 0

    init(book: Book) {
        self.book = book

        book.publisher(for: \.raw_completionPercent)
            .map({ Helpers.percentCalculator.rounded($0) })
            .assign(to: &$completionPercent)
    }

}

struct BookDetail: View {
    let book: Book

    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        self.book = book
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        VStack(alignment: .leading) {
            BookRow(book: book)

            Text(String(viewModel.completionPercent))

            ProgressView(value: viewModel.completionPercent, total: 100)
            {}
            currentValueLabel: { Text("\(viewModel.completionPercent)%") }

            SessionListBook(book: book)
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding([.horizontal, .top], 20)
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
                .previewLayout(.sizeThatFits)

            NavigationView {
                BookDetail(book: BookSeeder.preview.fetch(bookWith: .sessions))
                    .navigationBarTitle("", displayMode: .inline)
            }
            .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
