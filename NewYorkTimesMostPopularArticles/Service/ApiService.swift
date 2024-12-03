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

class APIService: APIServiceProtocol {
    private let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"
    private var apiKey: String {
        loadAPIKey()
    }
    /// Fetches articles from the New York Times API based on category and period.
    /// - Parameters:
    ///   - category: The category of the articles ("viewed", "emailed", "shared").
    ///   - period: The time period for the articles 1, 7, or 30 days). Default is 7 days.
    /// - Returns: A publisher that emits a list of `ArticleDTO` on success or an `APIServiceError` on failure.
    func fetchArticles(for category: String, period: Int = 7) -> AnyPublisher<[ArticleDTO], APIServiceError> {
        let endpoint = "\(category)/\(period).json?api-key=\(apiKey)"
        guard let url = URL(string: baseUrl + endpoint) else {
            return Fail(error: APIServiceError.invalidURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    throw APIServiceError.serverError((output.response as? HTTPURLResponse)?.statusCode ?? -1)
                }
                return output.data
            }
            .decode(type: Response.self, decoder: JSONDecoder())
            .map(\.results)
            .mapError { error -> APIServiceError in
                if let error = error as? APIServiceError {
                    return error
                } else if error is DecodingError {
                    return .decodingError
                } else {
                    return .networkError(error)
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
