//
//  FavouriteArticle.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation
import SwiftData

@Model
class FavouriteArticle {
    @Attribute(.unique) var id: Int64
    var url: String
    var title: String
    var byline: String
    var publishedDate: String
    var abstract: String
    var imageUrl: String?

    init(id: Int64, url: String, title: String, byline: String, publishedDate: String, abstract: String, imageUrl: String?) {
        self.id = id
        self.url = url
        self.title = title
        self.byline = byline
        self.publishedDate = publishedDate
        self.abstract = abstract
        self.imageUrl = imageUrl
    }
}
