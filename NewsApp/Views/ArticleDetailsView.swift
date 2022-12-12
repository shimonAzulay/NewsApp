//
//  ArticleDetailsView.swift
//  NewsApp
//
//  Created by Shimon Azulay on 09/12/2022.
//

import SwiftUI

struct ArticleDetailsView: View {
  var article: NewsFeedArticle
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 10) {
        VStack(alignment: .center) {
          AsyncImage(url: article.urlToImage, content: { image in
            image.resizable()
          }, placeholder: {
            ProgressView()
          })
          .frame(height: 230)
        }
        
        Text(article.title)
          .font(.system(size: 20))
          .bold()
        
        if let author = article.author {
          Text(author)
            .font(.system(size: 15))
        }

        if let publihsedAt = article.publishedAt {
          Text(publihsedAt)
            .font(.system(size: 10))
        }
        
        if let source = article.source {
          Text(source)
            .font(.system(size: 10))
        }
        
        Text(article.description)
          .font(.system(size: 17))
        
        if let url = article.url {
          Link(url.absoluteString, destination: url)
            .font(.system(size: 10))
        }
        
      }
    }
    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
  }
}
