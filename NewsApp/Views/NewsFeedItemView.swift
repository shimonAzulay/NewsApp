//
//  NewsItemView.swift
//  NewsApp
//
//  Created by Shimon Azulay on 08/12/2022.
//

import SwiftUI
import CachedAsyncImage

struct NewsFeedItemView: View {
  var article: NewsFeedArticle
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      CachedAsyncImage(url: article.urlToImage, content: { image in
        image.resizable()
      }, placeholder: {
        HStack(alignment: .center) {
          ProgressView()
        }
      })
      .frame(height: 200)
      Text(article.title)
        .font(.system(size: 15))
        .bold()
      if let author = article.author {
        Text(author)
          .font(.system(size: 10))
      }
      
      if let publihsedAt = article.publishedAt {
        Text(publihsedAt)
          .font(.system(size: 10))
      }
      
      if let source = article.source {
        Text(source)
          .font(.system(size: 8))
      }
    }
  }
}
