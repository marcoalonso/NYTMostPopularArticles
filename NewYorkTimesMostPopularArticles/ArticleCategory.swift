//
//  ArticleCategory.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import Foundation

enum ArticleCategory: String, CaseIterable {
    case emailed = "emailed"
    case shared = "shared"
    case viewed = "viewed"
    var displayName: String {
        switch self {
        case .emailed:
            return "Most Emailed Articles"
        case .shared:
            return "Most Shared on Facebook"
        case .viewed:
            return "Most Viewed Articles"
        }
    }
}
