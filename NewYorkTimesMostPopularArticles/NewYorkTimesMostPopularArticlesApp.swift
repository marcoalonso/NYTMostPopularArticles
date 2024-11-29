//
//  NewYorkTimesMostPopularArticlesApp.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI

@main
struct NewYorkTimesMostPopularArticlesApp: App {
    @StateObject private var viewModel = ArticlesViewModel(apiService: APIService())
    
    var body: some Scene {
        WindowGroup {
            ArticlesListView()
                .environmentObject(viewModel)
        }
    }
}
