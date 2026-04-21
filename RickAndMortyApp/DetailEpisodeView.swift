import SwiftUI
import RickMortySwiftApi

struct DetailEpisodeView: View {
    
    @StateObject var modelLoader = ModelLoader()
    @State var item: RMEpisodeModel?
    let needRandomEpisode: Bool
    @Binding var path: NavigationPath
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        VStack(spacing: 30) {
            if modelLoader.isLoading {
                ProgressView()
            } else {
                if item == nil {
                    if let randomEpisode = modelLoader.randomEpisode {
                        viewConstruct(item: randomEpisode)
                    }
                } else {
                    if let item = item {
                        viewConstruct(item: item)
                    }
                }
            }
            Spacer()
        }
        .alert("Ошибка", isPresented: .constant(modelLoader.errorMessage != nil), actions: {
            Button("OK") {
                modelLoader.errorMessage = nil
            }
        }, message: {
            Text(modelLoader.errorMessage ?? "")
        })
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if needRandomEpisode {
                await modelLoader.fletchRandomEpisode()
                if let randomEpisode = modelLoader.randomEpisode {
                    await modelLoader.getCharactersCustom(characterLinks: randomEpisode.characters)
                }
            } else {
                if let episode = item {
                    await modelLoader.getCharactersCustom(characterLinks: episode.characters)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewConstruct(item: RMEpisodeModel) -> some View {
        VStack {
            if modelLoader.isLoading {
                ProgressView()
            } else {
                VStack(alignment: .leading) {
                    Text("Наименование: ")
                        .boldHeadline() +
                    Text("\(item.name)")
                    Text("Дата выхода: ")
                        .boldHeadline() +
                    Text("\(item.airDate)")
                    Text("Код эпизода: ")
                        .boldHeadline() +
                    Text("\(item.episode)")
                }
                Divider()
                Text("Персонажи в эпизоде:")
                    .foregroundStyle(Color.secondary)
                    .font(Font.title.bold())
                    .font(.largeTitle)
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 5) {
                        if let charactersInEpisode = modelLoader.charactersInEpisode {
                            ForEach(charactersInEpisode.indices, id: \.self) { index in
                                NavigationLink(destination: DetailCharacterView(item: charactersInEpisode[index], needRandomCharacter: false, path: $path)) {
                                    ItemView(element: charactersInEpisode[index])
                                }
                            }
                        }
                    }.padding(.all, 5)
                }
            }
        }
        .padding(20)
        .navigationTitle(Text("Эпизод \(String(item.id))"))
    }
}
