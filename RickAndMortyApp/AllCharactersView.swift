import SwiftUI

struct AllCharactersView: View {
    @StateObject private var modelLoader = ModelLoader()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if modelLoader.isLoading {
                ProgressView()
            } else {
                VStack {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            if let characters = modelLoader.characters {
                                ForEach(characters.indices, id: \.self) { index in
                                    NavigationLink(destination: DetailCharacterView(item: characters[index], needRandomCharacter: false, path: $path)) {
                                        ItemView(element: characters[index])
                                    }
                                }
                            }
                        }
                        .padding(.all, 5)
                    }
                } .alert("Ошибка", isPresented: .constant(modelLoader.errorMessage != nil), actions: {
                    Button("OK") {
                        modelLoader.errorMessage = nil
                    }
                }, message: {
                    Text(modelLoader.errorMessage ?? "")
                })
                
            }
        }
        .navigationTitle("Персонажи")
        .task {
            await  modelLoader.fletchCharacters()
        }
    }
}

