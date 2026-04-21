
import SwiftUI
import RickMortySwiftApi

struct MainView: View  {
    @State var path = NavigationPath()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            //+
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    VStack (alignment: .center) {
                        VStack {
                            Text("Энциклопедия")
                            Text("Rick and Morty")
                        }.foregroundStyle(Color(.blue))
                            .padding([.top,.bottom], 20)
                            .font(Font.title.bold())
                            .rotation3DEffect(.degrees(-5), axis: (x: 0, y: 1, z: 1))
                        Image("allCharacters")
                            .subViewImageSet()
                        HStack {
                            RandomCharacterView(path: $path)
                            RandomEpisodeView(path: $path)
                        }
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                    .tag(0)
                    SearchView(path: $path)
                        .tag(1)
                    AllCharactersView(path: $path)
                        .tag(2)
                    AllEpisodesView(path: $path)
                        .tag(3)
                }
                HStack(spacing: 30) {
                    ForEach(0..<4) { index in
                        FloatingTabButton(
                            index: index,
                            selectedTab: $selectedTab
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                )
                .padding(.bottom, 20)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationDestination(for: Pages.self) { page in
                switch page {
                case .allCharacters:
                    AllCharactersView(path: $path)
                case .detailEpisode:
                    DetailEpisodeView(needRandomEpisode: false, path: $path)
                case .detailCharacter:
                    DetailCharacterView(needRandomCharacter: false, path: $path)
                case .randomCharacter:
                    DetailCharacterView(needRandomCharacter: true, path: $path)
                case .randomEpisode:
                    DetailEpisodeView(needRandomEpisode: true, path: $path)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        Spacer()
    }
}

struct ItemView: View {
    
    let element: RMCharacterModel
    var body: some View {
        
        VStack {
            if let url = URL(string: element.image) {
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
            
            Text(element.name)
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(width: 200)
        .frame(height: 230)
        .background(Color(red: 242, green: 242, blue: 247))
        .cornerRadius(8)
    }
}

#Preview {
    MainView()
}

struct FloatingTabButton: View {
    let index: Int
    @Binding var selectedTab: Int
    
    let titles = ["Главная", "Поиск", "Персонажи", "Эпизоды"]
    let icons = ["house", "magnifyingglass", "person", "film"]
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = index
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: icons[index])
                    .font(.system(size: selectedTab == index ? 28 : 22))
                    .foregroundColor(selectedTab == index ? .blue : .gray)
                
                if selectedTab == index {
                    Text(titles[index])
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.blue)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(width: 70)
            .padding(.vertical, 8)
        }
    }
}
