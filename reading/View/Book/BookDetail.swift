import Introspect
import SwiftUI

class BookDetailViewModel: ViewModel {
    @Published var newSessionButtonHidden = false
    @Published var newSessionInput = ""
}

struct BookDetail: View {
    @Environment(\.managedObjectContext) private var viewContext
    let book: Book
    @StateObject var viewModel = BookDetailViewModel()

    var addSessionButton: some View {
        HStack {
            Button {
                viewModel.newSessionButtonHidden = true
            } label: {
                Label("New Session", systemImage: "plus.circle.fill")
                    .font(Font.title3.bold())
                    .padding() // keep padding here to increase tap area
            }
            Spacer()
        }
        .background(Color(UIColor.systemGray6))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                Section {
                    BookProgress(book: book)
                }

                SessionListBook(sessions: book.sessions)
            }
            .onTapGesture {
                if viewModel.newSessionButtonHidden {
                    viewModel.newSessionButtonHidden = false
                }
            }
            .listStyle(InsetGroupedListStyle())

            HStack {
                if viewModel.newSessionButtonHidden {
                    HStack {
                        TextField("hello", text: $viewModel.newSessionInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .introspectTextField { $0.becomeFirstResponder() }

                        Image(systemName: "paperplane.circle.fill").font(.title)
                    }
                    .padding()
                } else {
                    addSessionButton
                }
            }
        }
        .navigationBarTitle(book.title)
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
