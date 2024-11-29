//
//  ArticlesListView.swift
//  NewYorkTimesMostPopularArticles
//
//  Created by Marco Alonso on 28/11/24.
//

import SwiftUI
import Kingfisher
import SwiftData

struct ArticlesListView: View {
    @EnvironmentObject var viewModel: ArticlesViewModel
    @Environment(\.modelContext) private var modelContext
    @Query private var favouriteArticles: [FavouriteArticle]
    @State private var selectedCategory: String = "viewed"
    @State private var selectedPeriod: Int = 7
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            VStack {
                // Picker para seleccionar la categoría
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

                // Picker para seleccionar el periodo
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

                // Mensaje de error
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Lista de artículos
                if viewModel.isConnected {
                    List(viewModel.articles, id: \.id) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            articleRow(article: article)
                        }
                    }
                } else if !favouriteArticles.isEmpty {
                    Text("Showing saved articles due to no internet connection.")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                    List(favouriteArticles, id: \.id) { favourite in
                        NavigationLink(destination: ArticleDetailView(article: ArticleMapper.mapToDTO(from: favourite))) {
                            articleRow(article: ArticleMapper.mapToDTO(from: favourite))
                        }
                    }
                } else {
                    Text("No articles available.")
                        .foregroundColor(.gray)
                        .italic()
                }
            }
            .navigationTitle("NYT - Popular Articles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save All") {
                        saveAllArticles()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Information"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.fetchArticles(for: selectedCategory, period: selectedPeriod)
            }
        }
    }

    // Vista reutilizable para la fila de artículo
    private func articleRow(article: ArticleDTO) -> some View {
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

    // Guardar todos los artículos
    private func saveAllArticles() {
        let existingIDs = Set(favouriteArticles.map { $0.id })
        let newArticles = viewModel.articles.filter { !existingIDs.contains(Int64($0.id)) }

        if newArticles.isEmpty {
            alertMessage = "All articles are already saved."
        } else {
            for article in newArticles {
                let favourite = ArticleMapper.mapToFavourite(from: article)
                modelContext.insert(favourite)
            }
            alertMessage = "\(newArticles.count) articles saved successfully."
        }
        showAlert = true
    }
}

