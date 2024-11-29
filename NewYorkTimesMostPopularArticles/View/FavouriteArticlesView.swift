//
//  FavouriteArticlesView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso Rodriguez on 28/11/24.
//

import SwiftUI
import SwiftData

struct FavouriteArticlesView: View {
    @Query private var favouriteArticles: [FavouriteArticle]

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                ForEach(favouriteArticles, id: \.id) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.byline)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteArticle)
            }
            .navigationTitle("Favourite Articles")
        }
    }

    private func deleteArticle(at offsets: IndexSet) {
        offsets.map { favouriteArticles[$0] }.forEach(modelContext.delete)
    }
}

#Preview {
    FavouriteArticlesView()
}
