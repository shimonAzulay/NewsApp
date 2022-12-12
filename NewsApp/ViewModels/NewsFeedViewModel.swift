//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Shimon Azulay on 08/12/2022.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
  private var page = 1
  @Published var news = [NewsFeedArticle]() {
    didSet {
      isEmpty = news.isEmpty
    }
  }
  @Published var isEmpty = true
  @Published var isFetchingMore = false
  
  let newsFetcher: NewsFetcher
  
  init(newsFetcher: NewsFetcher) {
    self.newsFetcher = newsFetcher
  }
  
  func fetch(filter: String = "") async throws {
    let articles = try await newsFetcher.fetchNews(of: filter,
                                                   page: 1,
                                                   perPage: 20)
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    DispatchQueue.main.async { [weak self] in
      self?.page = 2
      self?.news = articles
    }
  }
  
  func search(filter: String) async throws {
    DispatchQueue.main.async { [weak self] in
      self?.news.removeAll()
    }
    
    try await fetch(filter: filter)
  }
  
  func fetchMore(filter: String = "") async throws {
    DispatchQueue.main.async { [weak self] in
      self?.isFetchingMore = true
    }
    
    let articles = try await newsFetcher.fetchNews(of: filter,
                                                   page: page,
                                                   perPage: 20)
    try? await Task.sleep(nanoseconds: 2_000_000_000)
    
    DispatchQueue.main.async { [weak self] in
      self?.page += 1
      self?.isFetchingMore = false
      self?.news.append(contentsOf: articles)
    }
  }
}
