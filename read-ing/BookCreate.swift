import SwiftUI

struct BookCreate: View {
    @State var title = ""
    @State var authors = ""
    @State var pageCount = ""
//    @State var subtitle: String?
//    @State var image: Image?
//    @State var isEbook: Bool

//    @State var fields = [
//        "title": "",
//        "authors": "",
//        "pageCount": "",
//    ]

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                if title is long, propose subtitle?
//                try to guess the subtitle based on punctuation
                TextField("Author", text: $authors)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField(
                    "Pages",
                    text: $pageCount,
                    onEditingChanged: { (isEditing: Bool) in
                        print("onEditingChanged", isEditing)
                },
                    onCommit: {
                        print("onCommit", self.pageCount)
                })
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
            .navigationBarItems(leading: Button("Back") {})
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct BookCreate_Previews: PreviewProvider {
    static var previews: some View {
        BookCreate()
    }
}
