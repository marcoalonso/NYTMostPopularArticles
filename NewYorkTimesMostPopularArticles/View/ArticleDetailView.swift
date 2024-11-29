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
    let article: ArticleDTO

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
                if let imageUrl = article.media?.first?.mediaMetadata?.last?.url {
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
                    
                    Button(action: saveArticle) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                    
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
    }

    private func saveArticle() {
        let favourite = FavouriteArticle(
            id: article.id,
            url: article.url,
            title: article.title,
            byline: article.byline,
            publishedDate: article.publishedDate,
            abstract: article.abstract
        )
        modelContext.insert(favourite)
    }
}
#Preview {
    ArticleDetailView(article: MockData.sampleArticle)
}
