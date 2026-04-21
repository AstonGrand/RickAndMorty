import SwiftUI
import RickMortySwiftApi

struct SearchView: View {
    @StateObject private var modelLoader = ModelLoader()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            SearchBar(text: $modelLoader.searchText)
            
            if modelLoader.isLoading {
                ProgressView("Загрузка персонажей...")
                    .frame(maxHeight: .infinity)
            } else {
                if let filteredCharacters = modelLoader.filteredCharacters {
                    CharactersListView(modelLoader: modelLoader, path: $path, characters: filteredCharacters)
                }
            }
        }
        .navigationTitle("Персонажи")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await modelLoader.fletchCharacters()
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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Поиск по имени или эпизоду", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

struct CharactersListView: View {
    @StateObject var modelLoader: ModelLoader
    @Binding var path: NavigationPath
    let characters: [RMCharacterModel]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if characters.isEmpty {
                    EmptyStateView()
                } else {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(spacing: 0) {
                                ForEach(characters.indices, id: \.self) { index in
                                    NavigationLink(destination: DetailCharacterView(item: characters[index], needRandomCharacter: false, path: $path)) {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(characters[index].name)
                                                    .font(.headline)
                                                Text(characters[index].status)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Text(characters[index].origin.name)
                                        }
                                    }
                                }
                            }.padding(.all, 5)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("Персонажи не найдены")
                .font(.headline)
                .foregroundColor(.secondary)
            Text("Попробуйте изменить запрос поиска")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
}
