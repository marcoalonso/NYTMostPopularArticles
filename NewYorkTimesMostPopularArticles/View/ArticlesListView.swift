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
                // Picker to select the category
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

                // Picker to select the period
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

                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // List of articles
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

    /// Creates a row view to display a single article in a list.
    ///
    /// This method generates a `HStack` layout to show a thumbnail image (if available),
    /// the article's title, and its byline. The image is fetched asynchronously using the `Kingfisher`
    /// library, and the text is styled appropriately for a headline and subheadline.
    ///
    /// - Parameter article: The `ArticleDTO` object representing the article to display.
    /// - Returns: A `View` containing the layout for the article row.
    private func articleRow(article: ArticleDTO) -> some View {
        HStack {
            // Display the thumbnail image if available.
            if let imageUrl = article.media?.first?.mediaMetadata?.first?.url {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .frame(width: 50, height: 50) // Thumbnail dimensions
                    .cornerRadius(8) // Rounded corners for aesthetic
            }
            
            // Display the article title and byline.
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.headline) // Main title styling
                Text(article.byline)
                    .font(.subheadline) // Subtitle styling
                    .foregroundColor(.secondary) // Secondary text color
            }
        }
    }

    /// Saves all currently displayed articles to the favourites database.
    ///
    /// This method compares the articles currently displayed in the view model (`viewModel.articles`)
    /// with the existing favourite articles in the database. If an article is not already saved,
    /// it is added to the favourites. The method updates `alertMessage` to inform the user
    /// whether all articles were already saved or how many new articles were successfully saved.
    ///
    /// - Note: This method ensures that no duplicate articles are saved.
    ///         It triggers an alert to notify the user of the result.
    private func saveAllArticles() {
        // Step 1: Retrieve IDs of existing favourite articles.
        let existingIDs = Set(favouriteArticles.map { $0.id })
        
        // Step 2: Filter out articles already saved in the favourites.
        let newArticles = viewModel.articles.filter { !existingIDs.contains(Int64($0.id)) }
        
        // Step 3: Check if there are any new articles to save.
        if newArticles.isEmpty {
            // All articles are already saved.
            alertMessage = "All articles are already saved."
        } else {
            // Save new articles to favourites.
            for article in newArticles {
                let favourite = ArticleMapper.mapToFavourite(from: article)
                modelContext.insert(favourite)
            }
            // Update alert message with the count of saved articles.
            alertMessage = "\(newArticles.count) articles saved successfully."
        }
        
        // Step 4: Show the alert with the appropriate message.
        showAlert = true
    }
}

