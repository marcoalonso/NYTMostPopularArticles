//
//  ArticleMapper.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation

struct ArticleMapper {
    
    static func mapToDTO(from favourite: FavouriteArticle) -> ArticleDTO {
        return ArticleDTO(
            id: Int64(Int(favourite.id)),
            url: favourite.url,
            title: favourite.title,
            byline: favourite.byline,
            publishedDate: favourite.publishedDate,
            abstract: favourite.abstract,
            media: favourite.imageUrl != nil ? [
                Media(
                    type: "image",
                    subtype: "photo",
                    caption: nil,
                    mediaMetadata: [
                        MediaMetadata(
                            url: favourite.imageUrl!,
                            format: "Standard Thumbnail",
                            height: 75,
                            width: 75
                        )
                    ]
                )
            ] : nil
        )
    }

    static func mapToFavourite(from dto: ArticleDTO) -> FavouriteArticle {
        return FavouriteArticle(
            id: Int64(dto.id),
            url: dto.url,
            title: dto.title,
            byline: dto.byline,
            publishedDate: dto.publishedDate,
            abstract: dto.abstract,
            imageUrl: dto.imageUrl
        )
    }
}
