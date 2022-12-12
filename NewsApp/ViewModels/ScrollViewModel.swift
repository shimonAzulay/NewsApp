//
//  ScrollViewModel.swift
//  NewsApp
//
//  Created by Shimon Azulay on 11/12/2022.
//

import UIKit

class ScrollViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
  @Published var isEligibleToRefresh: Bool = false
  @Published var isRefreshing: Bool = false
  @Published var scrollOffset: CGFloat = 0
  @Published var contentOffset: CGFloat = 0
  @Published var progress: CGFloat = 0
  let eligibleToRefreshScrollOffsetValue: CGFloat = 150
  let gestureID: String = UUID().uuidString
  
  // MARK: Since We need to Know when the user Left the Screen to Start Refresh
  // Adding Pan Gesture To UI Main Application Window
  // With Simultaneous Gesture Desture
  // Thus it Wont disturb SwiftUI Scroll's And Gesture's
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }
  
  func addGesture() {
    let panGesture = UIPanGestureRecognizer(target: self,
                                            action: #selector(onGestureChange(gesture:)))
    panGesture.delegate = self
    panGesture.name = gestureID
    rootController.view.addGestureRecognizer(panGesture)
  }
  
  func removeGesture() {
    rootController.view.gestureRecognizers?.removeAll { $0.name == gestureID }
  }
  
  var rootController: UIViewController {
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return .init()
    }
    
    guard let root = screen.windows.first?.rootViewController else {
      return .init()
    }
    
    return root
  }
  
  @objc func onGestureChange(gesture: UIPanGestureRecognizer) {
    if gesture.state == .cancelled || gesture.state == .ended {
      if isRefreshing == false {
        isEligibleToRefresh = scrollOffset > eligibleToRefreshScrollOffsetValue
      }
    }
  }
}
