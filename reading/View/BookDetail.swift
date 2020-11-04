import SwiftUI
import CoreData
import Combine

class BookDetailViewModel: ObservableObject {
    let book: Book

    @Published var raw_completionPercent: Double = 0

    private var cancellables = Set<AnyCancellable>()

    init(book: Book) {
        self.book = book
        raw_completionPercentPublisher.assign(to: &$raw_completionPercent)
    }

    var raw_completionPercentPublisher: AnyPublisher<Double, Never> {
        book.publisher(for: \.raw_completionPercent)
            .map { Double($0) }
            .eraseToAnyPublisher()
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

            Text("\(viewModel.raw_completionPercent)")

            ProgressView(value: viewModel.raw_completionPercent, total: 1000)
            {}
            currentValueLabel: { Text("\(viewModel.raw_completionPercent)%") }

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
