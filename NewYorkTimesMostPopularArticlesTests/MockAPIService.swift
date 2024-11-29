//
//  MockAPIService.swift
//  NewYorkTimesMostPopularArticlesTests
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation
import Combine
@testable import NewYorkTimesMostPopularArticles

class MockAPIService: APIServiceProtocol {
    var result: Result<[ArticleDTO], APIServiceError>?

    func fetchArticles(for category: String, period: Int) -> AnyPublisher<[ArticleDTO], APIServiceError> {
        if let result = result {
            return Result.Publisher(result).eraseToAnyPublisher()
        } else {
            return Fail(error: APIServiceError.unknownError).eraseToAnyPublisher()
        }
    }
}
