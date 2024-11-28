//
//  ApiService.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation
import Combine

enum APIServiceError: Error, LocalizedError {
    case invalidURL
    case responseError
    case decodingError
    case networkError(Error)
    case serverError(Int)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid. Please try again."
        case .responseError:
            return "Failed to fetch data from the server. Please check your connection."
        case .decodingError:
            return "Failed to process the data received."
        case .networkError(let error):
            return error.localizedDescription
        case .serverError(let code):
            return "Server responded with an error: \(code)."
        case .unknownError:
            return "An unknown error occurred. Please try again later."
        }
    }
}

class APIService {
    private let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
    private var apiKey: String {
        loadAPIKey()
    }
    func fetchArticles(for category: String, period: Int = 7) -> AnyPublisher<[ArticleDTO], APIServiceError> {
        let endpoint = "\(category)/\(period).json?api-key=\(apiKey)"
        guard let url = URL(string: baseUrl + endpoint) else {
            return Fail(error: APIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .map(\.results)
            .mapError { error in
                if error is DecodingError {
                    return APIServiceError.decodingError
                } else {
                    return APIServiceError.responseError
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func loadAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let secrets = NSDictionary(contentsOfFile: path),
              let apiKey = secrets["API_KEY"] as? String else {
            fatalError("No se encontró Secrets.plist o la API Key")
        }
        return apiKey
    }
}
