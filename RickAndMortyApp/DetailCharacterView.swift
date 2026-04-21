import SwiftUI
import RickMortySwiftApi

struct DetailCharacterView: View {
    
    var item: RMCharacterModel?
    let needRandomCharacter: Bool
    @StateObject var modelLoader = ModelLoader()
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color(red: 242/255, green: 242/255, blue: 247/225)
                .ignoresSafeArea()
            VStack {
                if modelLoader.isLoading {
                    ProgressView()
                } else {
                    if item == nil {
                        if let randomCharacter = modelLoader.randomCharacter {
                            viewConstruct(item: randomCharacter)
                        }
                    } else {
                        if let item = item {
                            viewConstruct(item: item)
                        }
                    }
                }
                
            }
        }
        .alert("Ошибка", isPresented: .constant(modelLoader.errorMessage != nil), actions: {
            Button("OK") {
                modelLoader.errorMessage = nil
            }
        }, message: {
            Text(modelLoader.errorMessage ?? "")
        })
        .task {
            if needRandomCharacter {
                await modelLoader.fletchRandomCharacter()
                if let randomCharacter = modelLoader.randomCharacter {
                    await modelLoader.getEpisodesCustom(episodesLinks: randomCharacter.episode)
                }
            } else {
                if let character = item {
                    await modelLoader.getEpisodesCustom(episodesLinks: character.episode)
                }
            }
        }
    }
    
    @ViewBuilder
    private func viewConstruct(item: RMCharacterModel) -> some View {
        ScrollView {
            VStack(spacing: 30) {
                if modelLoader.isLoading {
                    ProgressView()
                } else {
                    if let url = URL(string: item.image) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 200, height: 200)
                            case .success(let image):
                                image
                                    .iconSet()
                            case .failure:
                                Image(systemName: "photo")
                                    .iconSet()
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    Text(item.name)
                        .font(.largeTitle)
                        .bold()
                    
                    VStack(alignment: .leading) {
                        Text("Status: ")
                            .boldHeadline() +
                        Text(item.status)
                        Text("Species: ")
                            .boldHeadline() +
                        Text(item.species)
                        Text("Type: ")
                            .boldHeadline() +
                        Text(item.type)
                        Text("Gender: ")
                            .boldHeadline() +
                        Text(item.gender)
                        Text("Origin: ")
                            .boldHeadline() +
                        Text(item.origin.name)
                        Text("Location: ")
                            .boldHeadline() +
                        Text(item.location.name)
                    }.font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Divider()
                    Text("Встречается в эпизодах:")
                        .foregroundStyle(Color.secondary)
                        .font(Font.title.bold())
                        .font(.largeTitle)
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            if let episodesInCharacter = modelLoader.episodesInCharacter {
                                ForEach(episodesInCharacter.indices, id: \.self) { index in
                                    NavigationLink(destination: DetailEpisodeView(item: episodesInCharacter[index], needRandomEpisode: false, path: $path)) {
                                        VStack(alignment: .leading) {
                                            Text(episodesInCharacter[index].name)
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                            Text(episodesInCharacter[index].episode)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }
                        }.padding(.all, 10)
                    }
                }
                Spacer()
            }
            .navigationTitle("Персонаж")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

