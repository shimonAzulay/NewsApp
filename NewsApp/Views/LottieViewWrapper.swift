//
//  ResizbaleLottieView.swift
//  NewsApp
//
//  Created by Shimon Azulay on 11/12/2022.
//

import Foundation
import Lottie
import SwiftUI

struct LottieViewWrapper: UIViewRepresentable {
  var fileName: String
  @Binding var isPlaying: Bool
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    view.backgroundColor = .clear
    addLottieView(view: view)
    return view
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
    uiView.subviews.forEach { view in
      if view.tag == 1009,
         let lottieView = view as? AnimationView {
        if isPlaying {
          lottieView.play()
        }else{
          lottieView.pause()
        }
      }
    }
  }
  
  func addLottieView(view to: UIView) {
    let lottieView = AnimationView(name: fileName)
    lottieView.backgroundColor = UIColor.clear
    lottieView.tag = 1009
    lottieView.translatesAutoresizingMaskIntoConstraints = false
    
    let constraints = [
      lottieView.widthAnchor.constraint(equalTo: to.widthAnchor),
      lottieView.heightAnchor.constraint(equalTo: to.heightAnchor),
    ]
    
    to.addSubview(lottieView)
    to.addConstraints(constraints)
  }
}

