import SwiftUI
import RickMortySwiftApi

struct RandomCharacterView: View {
    @StateObject private var modelLoader = ModelLoader()
    var randomCharacter: RMCharacterModel?
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Button {
                path.append(Pages.randomCharacter)
            } label: {
                VStack {
                    Image("randomCharacter")
                        .subViewImageSet()
                    Text("Случайный персонаж")
                        .font(Font.title2.bold())
                }
            }
        }
    }
}

