//
//  ArticlesViewModelTests.swift
//  NewYorkTimesMostPopularArticlesTests
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import XCTest
import Combine
@testable import NewYorkTimesMostPopularArticles

final class ArticlesViewModelTests: XCTestCase {
    private var viewModel: ArticlesViewModel!
    private var mockAPIService: MockAPIService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = ArticlesViewModel(apiService: mockAPIService)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() {
        let mockArticles = [
            ArticleDTO(id: 1, url: "https://example.com", title: "Test Article", byline: "Author", publishedDate: "2024-11-28", abstract: "Abstract", media: [])
        ]
        
        mockAPIService.result = .success(mockArticles)
        
        let expectation = XCTestExpectation(description: "ArticlesViewModel actualiza correctamente los artículos")
        
        viewModel.$articles
            .dropFirst()
            .sink { articles in
                XCTAssertEqual(articles.count, 1)
                XCTAssertEqual(articles.first?.title, "Test Article")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchArticles(for: "mostViewed")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
