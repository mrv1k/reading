import SwiftUI

class BookDetailViewModel: ViewModel {
    var book: Book

    var bookProgress: BookProgressViewModel
    var sessionCreateField: SessionCreateFieldViewModel
    var sessionListBook: SessionListBookViewModel

    init(book: Book) {
        self.book = book

        bookProgress = BookProgressViewModel(book: book, showLabel: true)
        sessionCreateField = SessionCreateFieldViewModel(book: book)
        sessionListBook = SessionListBookViewModel(book: book)
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            BookRow(book: viewModel.book)

            BookProgress(viewModel: viewModel.bookProgress)

            SessionListBook(viewModel: viewModel.sessionListBook)

            SessionCreateField(viewModel: viewModel.sessionCreateField)
        })
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
