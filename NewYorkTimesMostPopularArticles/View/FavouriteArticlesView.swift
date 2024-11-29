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
                    NavigationLink(destination: ArticleDetailView(article: convertToArticleDTO(favourite: article))) {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.byline)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteArticle)
            }
            .navigationTitle("Favourite Articles")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func deleteArticle(at offsets: IndexSet) {
        for index in offsets {
            let articleToDelete = favouriteArticles[index]
            modelContext.delete(articleToDelete)
        }
    }

    /// convertToArticleDTO is used to transform an instance of FavouriteArticle into an instance of ArticleDTO.
    ///
    /// - Parameter favourite :FavouriteArticle the model representing articles saved in favourites and sourced from SwiftData
    /// - Returns: ArticleDTO - the model used by the application to handle data from the API and views
    private func convertToArticleDTO(favourite: FavouriteArticle) -> ArticleDTO {
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
}

#Preview {
    FavouriteArticlesView()
}
