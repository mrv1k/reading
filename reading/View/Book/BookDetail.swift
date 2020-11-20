import SwiftUI

class BookDetailViewModel: ViewModel {
    private var book: Book

    var bookProgress: BookProgressViewModel
    var sessionListBook: SessionListBookViewModel
//    var sessionCreateField: SessionCreateFieldViewModel

    var sessionSetSnapshot: NSOrderedSet?

    init(book: Book)
    {
        print("BookDetail VM")
        self.book = book
        sessionSetSnapshot = self.book.sessionsSet

        self.bookProgress = BookProgressViewModel(book: book, showLabel: true)
        self.sessionListBook = SessionListBookViewModel(book: book)
//        self.sessionCreateField = SessionCreateFieldViewModel(book: book)
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        ScrollView(content: {
//            BookRow(book: book)

            BookProgress(viewModel: viewModel.bookProgress)

//            SessionCreateField(book: book)

            SessionListBook(viewModel: viewModel.sessionListBook)
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
