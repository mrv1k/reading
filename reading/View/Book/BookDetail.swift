import SwiftUI

class BookDetailViewModel: ViewModel {
    var book: Book

    var bookProgress: BookProgressViewModel
//    var sessionListBook: SessionListBookViewModel
    var sessionCreateField: SessionCreateFieldViewModel

    init(book: Book) {
        self.book = book

        self.bookProgress = BookProgressViewModel(book: book, showLabel: true)
//        self.sessionListBook = SessionListBookViewModel(book: book)
        self.sessionCreateField = SessionCreateFieldViewModel(book: book)
        print("init")
    }

    deinit {
        print("deinit")
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
        print("BookDetail init")
    }

    var body: some View {
        ScrollView(showsIndicators: false, content: {
            BookRow(book: viewModel.book)

            BookProgress(viewModel: viewModel.bookProgress)

//            SessionListBook(viewModel: viewModel.sessionListBook)
            SessionListBook(book: viewModel.book)

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
