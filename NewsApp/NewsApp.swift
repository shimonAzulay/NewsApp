//
//  NewsApp.swift
//  NewsApp
//
//  Created by Shimon Azulay on 08/12/2022.
//

import SwiftUI

@main
struct NewsApp: App {
  var body: some Scene {
    WindowGroup {
      NewsFeedView(viewModel: .init(newsFetcher: NewsApiFetcher()))
    }
  }
}
