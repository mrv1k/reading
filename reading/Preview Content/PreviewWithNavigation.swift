import SwiftUI

struct PreviewWithNavigation<Content: View>: View {
    let backButton = Button(action: { print("preview back click") }) {
        Image(systemName: "chevron.left")
    }

    let viewBuilder: () -> Content

    var body: some View {
        NavigationView {
            viewBuilder()
                .navigationBarItems(leading: backButton)
        }
    }
}

struct PreviewWithNavigation_Previews: PreviewProvider {
    // use to preview views that are nested inside NavigationView
    static var previews: some View {
        Group {
            PreviewWithNavigation {
                BookCreate_Previews.previews
            }
            PreviewWithNavigation {
                BookDetail_Previews.previews
            }
        }
    }
}
