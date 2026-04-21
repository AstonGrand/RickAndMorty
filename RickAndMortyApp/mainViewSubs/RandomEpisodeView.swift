import SwiftUI
import RickMortySwiftApi

struct RandomEpisodeView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        Button {
            path.append(Pages.randomEpisode)
        } label: {
            VStack {
                Image("randomEpisode")
                    .subViewImageSet()
                Text("Случайный эпизод")
                    .font(Font.title2.bold())
                    .foregroundStyle(Color(.blue))
            }
        }
    }
}
