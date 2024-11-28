//
//  ArticleResponse.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation

struct Response: Decodable {
    let status: String
    let results: [ArticleDTO]
}
struct ArticleDTO: Decodable {
    let id: Int64
    let url: String
    let title: String
    let byline: String
    let publishedDate: String
    let abstract: String
    let media: [Media]?
    enum CodingKeys: String, CodingKey {
        case id
        case url
        case title
        case byline
        case publishedDate = "published_date"
        case abstract
        case media
    }
}
struct Media: Decodable {
    let type: String
    let subtype: String
    let caption: String?
    let mediaMetadata: [MediaMetadata]?
    enum CodingKeys: String, CodingKey {
        case type
        case subtype
        case caption
        case mediaMetadata = "media-metadata"
    }
}
struct MediaMetadata: Decodable {
    let url: String
    let format: String
    let height: Int
    let width: Int
}
