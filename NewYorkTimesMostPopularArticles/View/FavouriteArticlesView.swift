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
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                if favouriteArticles.isEmpty {
                    Text("No favourite articles to display.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(favouriteArticles, id: \.id) { article in
                            NavigationLink(destination: ArticleDetailView(article: ArticleMapper.mapToDTO(from: article))) {
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
                }
            }
            .navigationTitle("Favourite Articles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .alert("Delete All Articles", isPresented: $showAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Delete", role: .destructive, action: deleteAllArticles)
                    } message: {
                        Text("Are you sure you want to delete all favourite articles?")
                    }
                }
            }
        }
    }

    /// Deletes one or more favourite articles from the database.
    ///
    /// This function is triggered when the user performs a swipe-to-delete action on a list row.
    /// It retrieves the articles at the specified offsets and removes them from the SwiftData context.
    ///
    /// - Parameter offsets: The index set representing the positions of the articles to be deleted in the list.
    private func deleteArticle(at offsets: IndexSet) {
        for index in offsets {
            let articleToDelete = favouriteArticles[index]
            modelContext.delete(articleToDelete)
        }
    }

    /// Deletes all favourite articles from the database.
    ///
    /// This function iterates through all articles currently saved in `favouriteArticles`
    /// and removes them from the SwiftData context.
    ///
    /// - Note: This is typically used for a bulk deletion operation initiated by the user.
    private func deleteAllArticles() {
        for article in favouriteArticles {
            modelContext.delete(article)
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
