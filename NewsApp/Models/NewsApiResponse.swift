//
//  NewsApiResponse.swift
//  NewsApp
//
//  Created by Shimon Azulay on 08/12/2022.
//

import Foundation

struct NewsApiResponse: Decodable {
  let articles: [NewsApiArticle]
}

struct NewsApiArticle: Decodable {
  var source: String?
  var author: String?
  var title: String?
  var url: URL?
  var urlToImage: URL?
  var publishedAt: String?
  var description: String?
  
  enum OuterKeys: String, CodingKey {
    case title, url, urlToImage, publishedAt, description, source, author
  }
  
  enum SourceKeys: String, CodingKey {
    case id, name
  }
  
  init(from decoder: Decoder) throws {
    let outerContainer = try decoder.container(keyedBy: OuterKeys.self)
    let sourceContainer = try outerContainer.nestedContainer(keyedBy: SourceKeys.self,
                                                             forKey: .source)
    
    self.source = try sourceContainer.decode(String?.self, forKey: .name)
    
    self.author = try outerContainer.decode(String?.self, forKey: .author)
    self.title = try outerContainer.decode(String?.self, forKey: .title)
    self.url = try? outerContainer.decode(URL?.self, forKey: .url)
    self.urlToImage = try? outerContainer.decode(URL?.self, forKey: .urlToImage)
    self.publishedAt = try outerContainer.decode(String?.self, forKey: .publishedAt)
    self.description = try outerContainer.decode(String?.self, forKey: .description)
  }
}
