import SwiftUI

struct BookDetail: View {
    @State var book: Book
    
    var body: some View {
        NavigationView {
            Form {
                TextField("", text: $book.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("", text: $book.author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("", text: $book.pageCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)


                Button("Add book") {
                    print("Add book")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(5.0)
            }
        }
        .navigationBarTitle("Hello", displayMode: .inline)
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        BookDetail(book: sampleBookList[0])
    }
}
