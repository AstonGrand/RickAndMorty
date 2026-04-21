import SwiftUI

struct AllCharactersSubView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Button {
                path.append(Pages.allCharacters)
            } label: {
                VStack {
                    Image("allCharacters")
                        .subViewImageSet()
                    Text("Все персонажи")
                        .font(Font.largeTitle.bold())
                        .foregroundStyle(Color(.blue))
                }
            }
        }
    }
}

