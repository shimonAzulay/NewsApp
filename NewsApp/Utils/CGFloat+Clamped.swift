//
//  CGFloat+Clamped.swift
//  NewsApp
//
//  Created by Shimon Azulay on 12/12/2022.
//

import Foundation

extension CGFloat {
  func clamped(range: ClosedRange<CGFloat>) -> CGFloat {
    CGFloat.minimum(CGFloat.maximum(range.lowerBound, self), range.upperBound)
  }
}
