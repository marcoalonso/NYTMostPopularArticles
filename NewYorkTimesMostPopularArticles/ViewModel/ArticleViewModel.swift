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
                }
            )
            .store(in: &cancellables)
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
    
   

