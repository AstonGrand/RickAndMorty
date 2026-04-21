import SwiftUI
import RickMortySwiftApi

struct AllEpisodesView: View {
    @StateObject private var modelLoader = ModelLoader()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if modelLoader.isLoading {
                ProgressView()
            } else {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            if let episodes = modelLoader.episodes {
                                ForEach(episodes.indices, id: \.self) { index in
                                    NavigationLink(destination: DetailEpisodeView(item: episodes[index], needRandomEpisode: false, path: $path)) {
                                        HStack() {
                                            Text(episodes[index].name)
                                                .font(.headline)
                                                .multilineTextAlignment(.leading)
                                            
                                            Spacer()
                                            Text(episodes[index].episode)
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }.padding(.all, 5)
                                        
                                    }
                                    if index != episodes.count - 1 {
                                        Divider()
                                            .padding(.leading, 16)
                                    }
                                }
                            }
                        }.padding(.all, 5)
                    }
                }
                .alert("Ошибка", isPresented: .constant(modelLoader.errorMessage != nil), actions: {
                    Button("OK") {
                        modelLoader.errorMessage = nil
                    }
                }, message: {
                    Text(modelLoader.errorMessage ?? "")
                })
            }
        }
        .task {
            await modelLoader.fletchEpisodes()
        }
    }
}

