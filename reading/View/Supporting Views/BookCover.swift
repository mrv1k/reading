import SwiftUI

struct BookCover: View {
    var cover: String?

//    https://stackoverflow.com/questions/56517610/conditionally-use-view-in-swiftui
//    @ViewBuilder
    var body: some View {
        Group {
            if cover != nil {
                Image(cover!)
                    .frame(width: 225, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .border(Color.black)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 225, height: 300)
                    .aspectRatio(contentMode: .fit)
                    .border(Color.black)
            }
        }
    }
}

struct BookCover_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BookCover(cover: "swift_book_cover")
            BookCover()
        }
    }
}
