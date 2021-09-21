//
//  HeadQuarter.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class HeadQuarter {
  static let shared: HeadQuarter = HeadQuarter()
  private var operationQueue = OperationQueue()
  
  private init() {
    operationQueue.maxConcurrentOperationCount = 1
  }
  
  func evaluate(customer: Customer,
                firstCompletion: @escaping (_: Customer) -> Void,
                completionHandler: @escaping (_: Customer) -> Void) {
    let task = HeadQuarterTask(customer: customer,
                               firstHandler: firstCompletion,
                               completionHandler: completionHandler)
    operationQueue.addOperations( [task] , waitUntilFinished: true)
  }
}
