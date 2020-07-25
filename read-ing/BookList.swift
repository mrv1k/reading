import SwiftUI

struct BookList: View {
//    @State private var books: [Book] = sampleBookArray
    @EnvironmentObject private var userData: UserData

    var body: some View {
        NavigationView {
            List {
                ForEach(userData.books) { book in
                    NavigationLink(
                        destination: BookDetail(book: book)
                    ) {
                        BookRow(book: book)
                            .environmentObject(self.userData)
                    }
                }

                Button(action: {
                    print(self.userData.books)
                    print(self.userData.books.count, sampleBookArray.count)
                }) {
                    Text("Log")
                }
            }
            .navigationBarItems(trailing: NavigationLink(destination: BookCreate()) {
                Text("Add")
            })
            .navigationBarTitle("Books", displayMode: .inline)
        }
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        BookList()
            .environmentObject(UserData())
    }
}
