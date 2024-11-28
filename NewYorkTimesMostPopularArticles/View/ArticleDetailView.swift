//
//  ArticleDetailView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI
import Kingfisher

struct ArticleDetailView: View {
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
                Link("Read Full Article", destination: URL(string: article.url)!)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    ArticleDetailView(article: MockData.sampleArticle)
}
