//
//  MockModelContext.swift
//  NewYorkTimesMostPopularArticlesTests
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import Foundation
import XCTest
import SwiftUI
import Combine
@testable import NewYorkTimesMostPopularArticles

class MockModelContext: ObservableObject {
    @Published var favouriteArticles: [FavouriteArticle] = []
    
    func addFavourite(article: FavouriteArticle) {
        favouriteArticles.append(article)
    }
    
    func deleteFavourite(article: FavouriteArticle) {
        if let index = favouriteArticles.firstIndex(where: { $0.id == article.id }) {
            favouriteArticles.remove(at: index)
        }
    }
}
