import SwiftUI

struct PreviewWithNavigation: View {
    var anyView: AnyView

    var backButton = Button(action: {}) {
        Image(systemName: "chevron.left")
    }

    var body: some View {
        NavigationView {
            anyView
            .navigationBarItems(leading: Button(action: {}) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("%title%")
                }
            })
        }
    }
}

struct PreviewWithNavigation_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWithNavigation(
            anyView: AnyView(
                BookDetail(book: sampleBookWith["everything"]!)
            )
        )
    }
}
