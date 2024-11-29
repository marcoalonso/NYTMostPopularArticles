//
//  ArticleMapperTests.swift
//  NewYorkTimesMostPopularArticlesTests
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import XCTest
@testable import NewYorkTimesMostPopularArticles

final class ArticleMapperTests: XCTestCase {

    func testMapToDTO() {
        let favourite = FavouriteArticle(
            id: 123,
            url: "https://example.com",
            title: "Test Article",
            byline: "By Tester",
            publishedDate: "2024-11-28",
            abstract: "This is a test article.",
            imageUrl: "https://example.com/image.jpg"
        )
        
        let dto = ArticleMapper.mapToDTO(from: favourite)
        
        XCTAssertEqual(dto.id, 123)
        XCTAssertEqual(dto.url, "https://example.com")
        XCTAssertEqual(dto.title, "Test Article")
        XCTAssertEqual(dto.byline, "By Tester")
        XCTAssertEqual(dto.publishedDate, "2024-11-28")
        XCTAssertEqual(dto.abstract, "This is a test article.")
        XCTAssertEqual(dto.imageUrl, "https://example.com/image.jpg")
    }
    
    func testMapToFavourite() {
        let dto = ArticleDTO(
            id: 123,
            url: "https://example.com",
            title: "Test Article",
            byline: "By Tester",
            publishedDate: "2024-11-28",
            abstract: "This is a test article.",
            media: [
                Media(
                    type: "image",
                    subtype: "photo",
                    caption: nil,
                    mediaMetadata: [
                        MediaMetadata(
                            url: "https://example.com/image.jpg",
                            format: "Standard Thumbnail",
                            height: 75,
                            width: 75
                        )
                    ]
                )
            ]
        )
        
        let favourite = ArticleMapper.mapToFavourite(from: dto)
        
        XCTAssertEqual(favourite.id, 123)
        XCTAssertEqual(favourite.url, "https://example.com")
        XCTAssertEqual(favourite.title, "Test Article")
        XCTAssertEqual(favourite.byline, "By Tester")
        XCTAssertEqual(favourite.publishedDate, "2024-11-28")
        XCTAssertEqual(favourite.abstract, "This is a test article.")
        XCTAssertEqual(favourite.imageUrl, "https://example.com/image.jpg")
    }

}
