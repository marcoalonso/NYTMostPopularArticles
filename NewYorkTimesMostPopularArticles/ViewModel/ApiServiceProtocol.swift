//
//  ApiServiceProtocol.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func fetchArticles(for category: String, period: Int) -> AnyPublisher<[ArticleDTO], APIServiceError>
}
