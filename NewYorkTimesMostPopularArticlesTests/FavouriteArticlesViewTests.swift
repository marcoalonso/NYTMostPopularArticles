//
//  FavouriteArticlesViewTests.swift
//  NewYorkTimesMostPopularArticlesTests
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import XCTest
import SwiftUI
import Combine
@testable import NewYorkTimesMostPopularArticles

final class FavouriteArticlesViewTests: XCTestCase {
    private var mockContext: MockModelContext!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockContext = MockModelContext()
        cancellables = []
    }
    
    override func tearDown() {
        mockContext = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFavouriteArticlesListDisplaysCorrectly() {
        let mockArticle = FavouriteArticle(
            id: 1,
            url: "https://example.com",
            title: "Test Article",
            byline: "Test Author",
            publishedDate: "2024-11-28",
            abstract: "This is a test abstract",
            imageUrl: "https://example.com/image.jpg"
        )
        mockContext.addFavourite(article: mockArticle)
        
        let view = FavouriteArticlesView()
            .environmentObject(mockContext)
        
        let viewController = UIHostingController(rootView: view)
        
        XCTAssertNotNil(viewController.view, "La vista debería cargarse correctamente")
        XCTAssertEqual(mockContext.favouriteArticles.count, 1, "Debería haber 1 artículo favorito en la lista")
        XCTAssertEqual(mockContext.favouriteArticles.first?.title, "Test Article", "El título del artículo debería coincidir")
    }
    
    func testRemoveFavouriteArticle() {
        let mockArticle = FavouriteArticle(
            id: 1,
            url: "https://example.com",
            title: "Test Article",
            byline: "Test Author",
            publishedDate: "2024-11-28",
            abstract: "This is a test abstract",
            imageUrl: "https://example.com/image.jpg"
        )
        mockContext.addFavourite(article: mockArticle)
        
        XCTAssertEqual(mockContext.favouriteArticles.count, 1, "Debería haber 1 artículo favorito inicialmente")
        
        mockContext.deleteFavourite(article: mockArticle)
        
        XCTAssertEqual(mockContext.favouriteArticles.count, 0, "No debería haber artículos favoritos después de eliminar")
    }
    
    func testNavigateToArticleDetailView() {
        let mockArticle = FavouriteArticle(
            id: 1,
            url: "https://example.com",
            title: "Test Article",
            byline: "Test Author",
            publishedDate: "2024-11-28",
            abstract: "This is a test abstract",
            imageUrl: "https://example.com/image.jpg"
        )
        mockContext.addFavourite(article: mockArticle)
        
        let view = FavouriteArticlesView()
            .environmentObject(mockContext)
        
        let viewController = UIHostingController(rootView: view)
        
        let selectedArticle = mockContext.favouriteArticles.first
        XCTAssertNotNil(selectedArticle, "El artículo seleccionado no debería ser nil")
        
        let detailView = ArticleDetailView(article: ArticleMapper.mapToDTO(from: selectedArticle!))
        XCTAssertNotNil(detailView, "La vista de detalle debería cargarse correctamente")
    }
}
