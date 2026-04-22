internal import Combine
import RickMortySwiftApi
import Foundation

final class ModelLoader: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var characters: [RMCharacterModel]?
    @Published var episodes: [RMEpisodeModel]?
    
    @Published var randomCharacter: RMCharacterModel?
    @Published var episodesInCharacter: [RMEpisodeModel]?
    
    @Published var randomEpisode: RMEpisodeModel?
    @Published var charactersInEpisode: [RMCharacterModel]?
    
    @Published var searchText = ""
    var filteredCharacters: [RMCharacterModel]? {
        if searchText.isEmpty {
            return characters
        } else {
            if let characters = characters {
                return characters.filter { character in
                    character.name.localizedCaseInsensitiveContains(searchText)
                }
            } else {
                return characters
            }
        }
    }
    
    private let store = ServiceStore()
    
    func getCharactersCustom(characterLinks: [String]) async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let rmClient = RMClient()
            let rmCharacter = RMCharacter(client: rmClient)
            let ids = characterLinks.compactMap { string in
                Int(string.split(separator: "/").last ?? "")
            }
            charactersInEpisode = try await rmCharacter.getCharactersByIDs(ids: ids)
        } catch {
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
    
    func fletchRandomEpisode() async  {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let rmClient = RMClient()
            let rmEpisodes = RMEpisode(client: rmClient)
            randomEpisode = try await rmEpisodes.getEpisodeByID(id: Int.random(in: 1...50))
        } catch {
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
    
    func fletchRandomCharacter() async  {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let rmClient = RMClient()
            let rmCharacters = RMCharacter(client: rmClient)
            randomCharacter = try await rmCharacters.getCharacterByID(id: Int.random(in: 1...825))
        } catch {
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
    
    func getEpisodesCustom(episodesLinks: [String]) async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            let rmClient = RMClient()
            let rmEpisode = RMEpisode(client: rmClient)
            
            let ids = episodesLinks.compactMap { string in
                Int(string.split(separator: "/").last ?? "")
            }
            if ids.count == 1 {
                episodesInCharacter = [try await rmEpisode.getEpisodeByID(id: ids[0])]
            } else {
                episodesInCharacter = try await rmEpisode.getEpisodesByIDs(ids: ids)
            }
        } catch {
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
    
    func fletchCharacters() async   {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            characters = try await store.loadCharacters()
        }
        catch {
            print("Catch: \(error)")
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
    
    func fletchEpisodes() async   {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            episodes = try await store.loadEpisodes()
        }
        catch {
            print("Catch: \(error)")
            errorMessage = NetworkError.decodingFailed(error).localizedDescription
        }
    }
}

private actor ServiceStore {
    func loadCharacters() async throws -> [RMCharacterModel]? {
        let rmClient = RMClient()
        let rmCharacters = RMCharacter(client: rmClient)
        let allCharacters = try await rmCharacters.getAllCharacters()
        return allCharacters
    }
    
    func loadEpisodes() async throws -> [RMEpisodeModel]? {
        let rmClient = RMClient()
        let rmEpisodes = RMEpisode(client: rmClient)
        let allEpisodes = try await rmEpisodes.getAllEpisodes()
        return allEpisodes
    }
}
