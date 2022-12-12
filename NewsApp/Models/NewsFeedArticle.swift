//
//  NewsFeedArticle.swift
//  NewsApp
//
//  Created by Shimon Azulay on 09/12/2022.
//

import Foundation

struct NewsFeedArticle: Identifiable {
  let id = UUID()
  let title: String
  let urlToImage: URL
  let description: String
  var publishedAt: String?
  var source: String?
  var author: String?
  var url: URL?
}
