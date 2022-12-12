//
//  ImageFetcher.swift
//  TopImages
//
//  Created by Shimon Azulay on 05/12/2022.
//

import Foundation

enum NewsFetcherError: Error {
  case badResponse
  case badResponseData
  case badUrlRequest
}

protocol NewsFetcher {
  func fetchNews(of filter: String,
                 page: Int,
                 perPage: Int) async throws -> [NewsFeedArticle]
  
  func fetchImageData(atUrl url: URL) async throws -> Data
}

class NewsApiFetcher: NewsFetcher {
  private let apiKey = "&apiKey=7806d7a294994cd2af9d272bbfe4f334"
  private let base = "https://newsapi.org"
  private let service = "/v2"
  
  func fetchNews(of filter: String,
                 page: Int,
                 perPage: Int) async throws -> [NewsFeedArticle] {
    guard let urlRequest = makeUrlRequest(of: filter,
                                          page: page,
                                          perPage: perPage) else {
      throw NewsFetcherError.badUrlRequest
    }
    
    print("Request: \(urlRequest)")
    return try await Task.retrying {
      let (data, response) = try await URLSession.shared.data(for: urlRequest)
      guard let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode else {
        throw NewsFetcherError.badResponse
      }
      
      let decoder = JSONDecoder()
      do {
        let newsApiResponse = try decoder.decode(NewsApiResponse.self, from: data)
        return newsApiResponse.articles.compactMap {
          guard let title = $0.title,
                let urlToImage = $0.urlToImage,
                let description = $0.description else { return nil }
          return NewsFeedArticle(title: title,
                                 urlToImage: urlToImage,
                                 description: description,
                                 publishedAt: $0.publishedAt,
                                 source: $0.source,
                                 author: $0.author,
                                 url: $0.url)
        }
      } catch {
        print("Decoding error: \(error)")
        throw NewsFetcherError.badResponseData
      }
    }
    .value
  }

  func fetchImageData(atUrl url: URL) async throws -> Data {
    return try await Task.retrying {
      try Data(contentsOf: url)
    }
    .value
  }
}

private extension NewsApiFetcher {
  func performFetchImageData(from url: URL) async throws -> Data {
    try Data(contentsOf: url)
  }
  
  func makeUrlRequest(of filter: String,
                      page: Int,
                      perPage: Int) -> URLRequest? {
    
    let page = "&page=\(page)"
    let perPage = "&pageSize=\(perPage)"
    
    var urlString = "\(base)\(service)"
    if filter.isEmpty {
      urlString += "\(Method.top)?country=us\(page)\(perPage)&sortBy=popularity\(apiKey)"
    } else {
      urlString += "\(Method.all)?q=\(filter)\(page)\(perPage)&sortBy=popularity\(apiKey)"
    }
    
    guard let url = URL(string: urlString) else { return nil }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    return urlRequest
  }
}

private enum Method: CustomStringConvertible {
  case all
  case top
  
  var description: String {
    switch self {
    case .all: return "/everything"
    case .top: return "/top-headlines"
    }
  }
}
