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

        let sessionsPublisher = book.publisher(for: \.sessions) .eraseToAnyPublisher()
        sessionListBook = SessionListBookViewModel(sessions: book.sessions, sessionsPublisher: sessionsPublisher)
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var body: some View {
        List {
            Section {
                BookProgress(viewModel: viewModel.bookProgress)
            }

            Section {
                SessionCreateField(viewModel: viewModel.sessionCreateField)
            }

            SessionListBook(viewModel: viewModel.sessionListBook)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(viewModel.book.title)
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


//Section(header: Text(Helpers.dateFormatters.date.string(from: Date()))) {
//    SessionRow(
//        viewModel: SessionRowViewModel(
//            createdAt: Date(),
//            progressPage: 13,
//            raw_progressPercent: 130,
//            reverse_showDayLabelPublisher: SessionSeeder.emptyBoolPublisher)
//    )
//}
