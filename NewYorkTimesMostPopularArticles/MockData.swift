//
//  MockData.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation

class MockData {
    static let sampleArticle: ArticleDTO = ArticleDTO(
        id: 123456,
        url: "https://www.example.com",
        title: "Sample Article Title",
        byline: "By Sample Author",
        publishedDate: "2024-11-28",
        abstract: "This is a sample abstract for the article. It gives a brief overview of the content.",
        media: [
            Media(
                type: "image",
                subtype: "photo",
                caption: "Sample caption for the image.",
                mediaMetadata: [
                    MediaMetadata(
                        url: "https://static01.nyt.com/images/sample-image.jpg",
                        format: "Standard Thumbnail",
                        height: 75,
                        width: 75
                    ),
                    MediaMetadata(
                        url: "https://static01.nyt.com/images/sample-image-large.jpg",
                        format: "Large",
                        height: 500,
                        width: 500
                    )
                ]
            )
        ]
    )
    
    static let sampleArticles: [ArticleDTO] = [
        ArticleDTO(
            id: 123456,
            url: "https://www.example.com",
            title: "Sample Article 1",
            byline: "By Author 1",
            publishedDate: "2024-11-28",
            abstract: "Abstract for Sample Article 1.",
            media: [
                Media(
                    type: "image",
                    subtype: "photo",
                    caption: "Sample caption for the image.",
                    mediaMetadata: [
                        MediaMetadata(
                            url: "https://static01.nyt.com/images/sample-image1.jpg",
                            format: "Standard Thumbnail",
                            height: 75,
                            width: 75
                        )
                    ]
                )
            ]
        ),
        ArticleDTO(
            id: 123457,
            url: "https://www.example.com/article2",
            title: "Sample Article 2",
            byline: "By Author 2",
            publishedDate: "2024-11-27",
            abstract: "Abstract for Sample Article 2.",
            media: [
                Media(
                    type: "image",
                    subtype: "photo",
                    caption: "Another sample caption.",
                    mediaMetadata: [
                        MediaMetadata(
                            url: "https://static01.nyt.com/images/sample-image2.jpg",
                            format: "Standard Thumbnail",
                            height: 75,
                            width: 75
                        )
                    ]
                )
            ]
        )
    ]
}
