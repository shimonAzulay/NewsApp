//
//  CustomRefreshView.swift
//  ShoeUI
//
//  Created by Balaji on 18/05/22.
//

import SwiftUI
import Lottie

struct RefreshableView<Content: View>: View {
  private let scrollCoordinateSpace = "SCROLL"
  var content: Content
  var showsIndicator: Bool
  var lottieFileName: String
  
  var onRefresh: () async -> Void
  init(showsIndicator: Bool = false,
       lottieFileName: String,
       @ViewBuilder content: @escaping () -> Content,
       onRefresh: @escaping () async -> Void) {
    self.showsIndicator = showsIndicator
    self.lottieFileName = lottieFileName
    self.content = content()
    self.onRefresh = onRefresh
  }
  
  @StateObject var scrollDelegate = ScrollViewModel()
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: showsIndicator) {
      VStack(spacing: 0) {
          LottieViewWrapper(fileName: lottieFileName,
                              isPlaying: $scrollDelegate.isRefreshing)
          .animation(.easeInOut(duration: 0.2), value: scrollDelegate.isEligibleToRefresh)
          .frame(height: scrollDelegate.eligibleToRefreshScrollOffsetValue * scrollDelegate.progress)
          .opacity(scrollDelegate.progress)
          .offset(y: scrollDelegate.isEligibleToRefresh ? -(scrollDelegate.contentOffset < 0 ? 0 : scrollDelegate.contentOffset ) : -(scrollDelegate.scrollOffset < 0 ? 0 : scrollDelegate.scrollOffset ))
        
        content
      }
      .offset(coordinateSpace: scrollCoordinateSpace) { offset in
        scrollDelegate.contentOffset = offset
        
        if !scrollDelegate.isEligibleToRefresh {
          scrollDelegate.progress = (offset / scrollDelegate.eligibleToRefreshScrollOffsetValue).clamped(range: 0...1)
          scrollDelegate.scrollOffset = offset
        }
        
        /* Debug
        print("progress: \(scrollDelegate.progress)")
        print("contentOffset: \(scrollDelegate.contentOffset)")
        print("scrollOffset: \(scrollDelegate.scrollOffset)")
        */
        
        if scrollDelegate.isEligibleToRefresh && !scrollDelegate.isRefreshing {
          scrollDelegate.isRefreshing = true
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
      }
    }
    .coordinateSpace(name: scrollCoordinateSpace)
    .onAppear(perform: scrollDelegate.addGesture)
    .onDisappear(perform: scrollDelegate.removeGesture)
    .onChange(of: scrollDelegate.isRefreshing) { isRefreshing in
      if isRefreshing {
        Task {
          await onRefresh()
          
          withAnimation(.easeInOut(duration: 0.25)) {
            scrollDelegate.progress = 0
            scrollDelegate.isEligibleToRefresh = false
            scrollDelegate.isRefreshing = false
            scrollDelegate.scrollOffset = 0
          }
        }
      }
    }
  }
}

extension View {
  @ViewBuilder
  func offset(coordinateSpace: String, offset: @escaping (CGFloat) -> Void) -> some View {
    self
      .overlay {
        GeometryReader{ proxy in
          let minY = proxy.frame(in: .named(coordinateSpace)).minY
          
          Color.clear
            .preference(key: OffsetKey.self, value: minY)
            .onPreferenceChange(OffsetKey.self) { value in
              offset(value)
            }
        }
      }
  }
}

struct OffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}
