//
//  NewYorkTimesMostPopularArticlesApp.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI
import SwiftData

@main
struct NewYorkTimesMostPopularArticlesApp: App {
    @StateObject private var viewModel = ArticlesViewModel(apiService: APIService())

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
        .modelContainer(for: FavouriteArticle.self) 
    }
}
