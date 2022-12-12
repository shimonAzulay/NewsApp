//
//  Task+Retry.swift
//  TopImages
//
//  Created by Shimon Azulay on 05/12/2022.
//

import Foundation

extension Task where Failure == Error {
  @discardableResult
  static func retrying(
    priority: TaskPriority? = nil,
    maxRetryCount: Int = 3,
    retryDelay: TimeInterval = 1,
    operation: @Sendable @escaping () async throws -> Success
  ) -> Task {
    Task(priority: priority) {
      for retry in 0..<maxRetryCount {
        do {
          return try await operation()
        } catch {
          print("Task failed with error: \(error)")
          print("retries left: \(maxRetryCount - retry - 1)")
          let oneSecond = TimeInterval(5_000_000_000)
          let delay = UInt64(oneSecond * retryDelay)
          try await Task<Never, Never>.sleep(nanoseconds: delay)
          
          continue
        }
      }
      
      try Task<Never, Never>.checkCancellation()
      return try await operation()
    }
  }
}

