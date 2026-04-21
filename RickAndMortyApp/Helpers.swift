import SwiftUI

extension Image {
    func iconSet() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: 200, height: 200)
    }
    
    func subViewImageSet() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 200)
    }
}

extension Text {
    func boldHeadline() -> Text {
        self
            .foregroundColor(.black)
            .bold()
            .font(.headline)
    }
}

enum Pages: Hashable {
    case allCharacters
    case detailCharacter
    case detailEpisode
    case randomCharacter
    case randomEpisode
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case serverError(statusCode: Int)
    case networkUnavailable
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Неверный URL адрес"
        case .noData:
            return "Сервер не вернул данные"
        case .decodingFailed(let error):
            return "Ошибка обработки данных: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Ошибка сервера. Код: \(statusCode)"
        case .networkUnavailable:
            return "Отсутствует подключение к интернету"
        }
    }
}
