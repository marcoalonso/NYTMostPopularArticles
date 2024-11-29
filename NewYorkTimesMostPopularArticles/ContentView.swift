//
//  ContentView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ArticlesListView()
                .tabItem {
                    Label("Articles", systemImage: "list.dash")
                }

            FavouriteArticlesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
