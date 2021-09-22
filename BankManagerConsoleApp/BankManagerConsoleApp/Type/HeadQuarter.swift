//
//  HeadQuarter.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/05/06.
//

import Foundation

final class HeadQuarter {
  static let shared: HeadQuarter = HeadQuarter()
  private var operationQueue = OperationQueue()
  
  private init() {
    operationQueue.maxConcurrentOperationCount = 1
  }
  
  func process(customer: Customer,
               preHandler: ((_: Customer) -> Void)?,
               completionHandler: ((_: Customer) -> Void)?) {
    let task = HeadQuarterTask(customer: customer)
    task.preHandler = preHandler
    task.completionHandler = completionHandler
    operationQueue.addOperations([task] , waitUntilFinished: true)
  }
}
