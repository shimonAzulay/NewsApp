//
//  NewsFeedView.swift
//  NewsApp
//
//  Created by Shimon Azulay on 08/12/2022.
//

import SwiftUI

struct NewsFeedView: View {
  @State private var searchText = ""
  @StateObject var viewModel: NewsFeedViewModel

  var body: some View {
    NavigationStack {
      RefreshableView(showsIndicator: false,
                        lottieFileName: "refreshing", content: {
        LazyVGrid(columns: [GridItem()]) {
          ForEach(viewModel.news) { article in
            NavigationLink(destination: {
              ArticleDetailsView(article: article)
            }, label: {
              NewsFeedItemView(article: article)
                .padding()
            })
            .buttonStyle(.plain)
          }
          if viewModel.isEmpty == false {
            Button("Load More") {
              Task {
                try? await viewModel.fetchMore(filter: searchText)
              }
            }
            .frame(width: 200, height: 100)
            .opacity(viewModel.isFetchingMore ? 0 : 1)
            .overlay {
              LottieViewWrapper(fileName: "fetchingMore",
                                  isPlaying: $viewModel.isFetchingMore)
              .opacity(viewModel.isFetchingMore ? 1 : 0)
            }
          }
        }
      }, onRefresh: {
        try? await viewModel.fetch(filter: searchText)
      })
      .overlay {
        LottieViewWrapper(fileName: "fetching",
                            isPlaying: $viewModel.isEmpty)
        .opacity(viewModel.isEmpty ? 1 : 0)
      }
    }
    .searchable(text: $searchText)
    .onChange(of: searchText) { searchText in
      Task {
        try? await viewModel.search(filter: searchText)
      }
    }
    .onAppear {
      Task {
        try? await viewModel.fetch()
      }
    }
  }
}
