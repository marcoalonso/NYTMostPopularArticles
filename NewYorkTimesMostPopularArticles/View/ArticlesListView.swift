//
//  ArticlesListView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI
import Kingfisher

struct ArticlesListView: View {
    @EnvironmentObject var viewModel: ArticlesViewModel
    @State private var selectedCategory: String = "viewed"
    @State private var selectedPeriod: Int = 7
    var body: some View {
        NavigationView {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    Text("Most Viewed").tag("viewed")
                    Text("Most Emailed").tag("emailed")
                    Text("Most Shared").tag("shared")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedCategory) { _, newValue in
                    viewModel.fetchArticles(for: newValue, period: selectedPeriod)
                }
                Picker("Period", selection: $selectedPeriod) {
                    Text("1 Day").tag(1)
                    Text("7 Days").tag(7)
                    Text("30 Days").tag(30)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedPeriod) { _, newValue in
                    viewModel.fetchArticles(for: selectedCategory, period: newValue)
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                List(viewModel.articles, id: \.id) { article in
                    NavigationLink(destination: ArticleDetailView(article: article)) {
                        HStack {
                            if let imageUrl = article.media?.first?.mediaMetadata?.first?.url {
                                KFImage(URL(string: imageUrl))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(8)
                            }
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.byline)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("NYT - Popular Articles")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchArticles(for: selectedCategory, period: selectedPeriod)
            }
        }
    }
}
#Preview {
    ArticlesListView()
}
