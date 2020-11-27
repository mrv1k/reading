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

        let sessionsPublisher = book.publisher(for: \.sessions).eraseToAnyPublisher()
        sessionListBook = SessionListBookViewModel(sessions: book.sessions, sessionsPublisher: sessionsPublisher)
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel
    @State private var editMode = EditMode.inactive

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    editMode = .active
                } label: {
                    Label("New Session", systemImage: "plus.circle.fill")
                        .font(Font.title3.bold())
                        .padding(.all)
                }
                Spacer()
            }
        }
    }

    var conditionalAddButton: some View {
        switch editMode {
        case .inactive: return AnyView(addButton)
        default: return AnyView(EmptyView())
        }
    }

    var conditionalEditButton: some View {
        switch editMode {
        case .active: return AnyView(EditButton())
        default: return AnyView(EmptyView())
        }
    }

    var conditionalSessionCreateField: some View {
        switch editMode {
        case .active: return AnyView(
            SessionCreateField(viewModel: viewModel.sessionCreateField)
        )
        default: return AnyView(EmptyView())
        }
    }


    var body: some View {
        ZStack {
            List {
                Section {
                    BookProgress(viewModel: viewModel.bookProgress)
                }

                conditionalSessionCreateField

                SessionListBook(viewModel: viewModel.sessionListBook)
            }
            .listStyle(InsetGroupedListStyle())

            conditionalAddButton
        }
        .navigationBarTitle(viewModel.book.title)
        .toolbar { conditionalEditButton }
        .environment(\.editMode, $editMode)
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
