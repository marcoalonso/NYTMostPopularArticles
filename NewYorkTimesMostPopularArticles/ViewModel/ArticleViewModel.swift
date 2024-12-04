//
//  ArticleViewModel.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation
import Combine
import Network

class ArticlesViewModel: ObservableObject {
    @Published var articles: [ArticleDTO] = []
    @Published var filteredArticles: [ArticleDTO] = [] 
    @Published var errorMessage: String?
    @Published var isConnected: Bool = true
    
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    /// Fetches articles for a specific category and time period from the API.
    ///
    /// This function uses the provided `APIService` to make a network call and fetch articles
    /// from a specified category and period. The articles are updated in the `articles` property.
    /// If there is no internet connection, the function exits without making the API call.
    ///
    /// - Parameters:
    ///   - category: A `String` representing the category of articles to fetch (e.g., "viewed", "emailed").
    ///   - period: An `Int` representing the time period to fetch articles for, in days (default is 7 days).
    ///
    /// - Note:
    ///   - The function checks the `isConnected` property to ensure there is an active internet connection before making the API request.
    ///   - In case of an error during the network call, the error message is set in `errorMessage`.
    ///   - The result of the API call updates the `articles` property with the fetched articles.
    func fetchArticles(for category: String, period: Int = 7) {
        guard isConnected else { return } // No hacer la llamada si no hay conexión

        errorMessage = nil // Resetear errores previos
        apiService.fetchArticles(for: category, period: period)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] articles in
                    self?.articles = articles
                    self?.filteredArticles = articles
                }
            )
            .store(in: &cancellables)
    }
    
    func filterArticles(by keyword: String) {
        if keyword.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { article in
                article.title.localizedCaseInsensitiveContains(keyword) ||
                article.abstract.localizedCaseInsensitiveContains(keyword)
            }
        }
    }
    
    private func mapErrorToMessage(_ error: APIServiceError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL. Please try again."
        case .responseError:
            return "Failed to fetch data from the server."
        case .decodingError:
            return "Failed to decode the data."
        case .networkError(_):
            return "Failed to fetch data because networkError."
        case .serverError(_):
            return "Failed to fetch data from the server, an internal server error occurred."
        case .unknownError:
            return "unknownError occurred."
        }
    }
}
    
   

