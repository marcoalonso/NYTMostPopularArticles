//
//  ArticleViewModel.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation
import Combine

class ArticlesViewModel: ObservableObject {
    @Published var articles: [ArticleDTO] = []
    @Published var errorMessage: String?
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    func fetchArticles(for category: String, period: Int = 7) {
        apiService.fetchArticles(for: category, period: period)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.errorMessage = self?.mapErrorToMessage(error)
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
        }
    }
}
