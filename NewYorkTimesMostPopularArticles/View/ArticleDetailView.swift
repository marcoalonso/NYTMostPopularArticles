//
//  ArticleDetailView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI
import Kingfisher
import SwiftData

struct ArticleDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favouriteArticles: [FavouriteArticle]

    let article: ArticleDTO
    @State private var isFavourite: Bool = false
    @State private var animateHeart: Bool = false
    @State private var showAlert: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.largeTitle)
                    .bold()
                Text(article.byline)
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text(article.publishedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if let imageUrl = getImageUrl() {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                }
                Text(article.abstract)
                    .font(.body)
                    .padding(.top)
                HStack {
                    Link("Read Full Article", destination: URL(string: article.url)!)
                    Button(action: toggleFavourite) {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavourite ? .red : .black)
                            .scaleEffect(animateHeart ? 1.3 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: animateHeart)
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkIfFavourite()
        }
        .alert("Added to Favourites", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    private func getImageUrl() -> String? {
        article.media?.first?.mediaMetadata?.last?.url ?? article.imageUrl
    }

    private func checkIfFavourite() {
        isFavourite = favouriteArticles.contains(where: { $0.id == article.id })
    }

    private func toggleFavourite() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        if isFavourite {
            removeFavourite()
        } else {
            addFavourite()
        }

        animateHeart = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animateHeart = false
        }
    }

    /**
     Adds the current article to the favorites list.

     This function creates a `FavouriteArticle` object using the current article data (`ArticleDTO`)
     and saves it to the database managed by SwiftData. It also updates the view state
     to reflect that the article has been marked as a favorite.

     - Important:
     This function assumes that `modelContext` is properly configured to handle insertion
     of the `FavouriteArticle` object.

     - Parameters:
     It has no parameters. It uses the current article provided by the view.

     - Side Effects:
     1. Inserts a new object into the SwiftData context.
     2. Changes the state of `isFavourite` to `true`.
     3. Triggers a visual alert confirming the action.

     - SeeAlso:
     `removeFavourite()` to remove an article from favorites.
     */
    private func addFavourite() {
        let favourite = FavouriteArticle(
            id: article.id,
            url: article.url,
            title: article.title,
            byline: article.byline,
            publishedDate: article.publishedDate,
            abstract: article.abstract,
            imageUrl: getImageUrl()
        )
        modelContext.insert(favourite)
        isFavourite = true
        showAlert = true
    }

    private func removeFavourite() {
        if let favourite = favouriteArticles.first(where: { $0.id == article.id }) {
            modelContext.delete(favourite)
        }
        isFavourite = false
    }
}
#Preview {
    ArticleDetailView(article: MockData.sampleArticle)
}
