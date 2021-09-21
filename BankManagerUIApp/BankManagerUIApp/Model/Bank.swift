//
//  Bank.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class Bank {
  private let operationQueue: OperationQueue = OperationQueue()
  private var firstHandler: (_ : Customer) -> Void = { _ in }
  private var secondHandler: (_ : Customer) -> Void = { _ in }
  private var thirdHandler: (_ : Customer) -> Void = { _ in }
  
  init(bankerCount: Int) {
    operationQueue.maxConcurrentOperationCount = bankerCount
  }
  
  init(bankerCount: Int, firstHandler: @escaping (_ : Customer) -> Void,
       secondHandler: @escaping (_ : Customer) -> Void,
       thirdHandler: @escaping (_ : Customer) -> Void) {
    operationQueue.maxConcurrentOperationCount = bankerCount
    self.firstHandler = firstHandler
    self.secondHandler = secondHandler
    self.thirdHandler = thirdHandler
  }

  func insertCustomers(count: Int) throws {
    let customers = try CustomerMaker().makeCustomer(count: count)
    
    for customer in customers {
      let task = BankTask(customer: customer, firstHandler: firstHandler,
      midHandler: secondHandler, completionHandler: thirdHandler)
      operationQueue.addOperation(task)
    }
  }
  
  func reset() {
    operationQueue.cancelAllOperations()
  }
}
