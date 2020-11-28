import SwiftUI

class BookDetailViewModel: ViewModel {
    var book: Book

    var bookProgress: BookProgressViewModel

    @Published var editMode = EditMode.inactive

    init(book: Book) {
        self.book = book

        bookProgress = BookProgressViewModel(book: book, showLabel: true)
    }
}

struct BookDetail: View {
    @StateObject var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = StateObject(wrappedValue: BookDetailViewModel(book: book))
    }

    var newSessionButton: some View {
        VStack {
            Spacer()
            HStack {
                Button {
                    viewModel.editMode = .active
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
        Group {
            if viewModel.editMode == .inactive {
                newSessionButton
            } else {
                EmptyView()
            }
        }
    }

    var conditionalEditButton: some View {
        Group {
            if viewModel.editMode == .active {
                EditButton()
            } else {
                EmptyView()
            }
        }
    }

    var body: some View {
        ZStack {
            List {
                Section {
                    BookProgress(viewModel: viewModel.bookProgress)
                }

                SessionListBook(sessions: viewModel.book.sessions, editModePublisher: viewModel.$editMode)
            }
            .listStyle(InsetGroupedListStyle())

            conditionalAddButton
        }
        .navigationBarTitle(viewModel.book.title)
        .toolbar { conditionalEditButton }
        .environment(\.editMode, $viewModel.editMode)
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
