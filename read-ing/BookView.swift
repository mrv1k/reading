import SwiftUI

struct BookView: View {

    @State var title: String = "Title"
    @State var author: String = "Author"
    @State var pageCount: String = "1000"

//    @State var book: Book
    
    var body: some View {
        NavigationView {
            Form {
                TextField("", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("", text: $author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("", text: $pageCount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)

                Button("Add book") {
                    print("mek")
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

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
//        BookView(book: Book(
//            title: "Crime and Punishment",
//            author: "Dostoevsky",
//            pageCount: 600
//            ))
    }
}
