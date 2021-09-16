//
//  BankManager.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class BankManager {
  var operationQueue: OperationQueue
  var customers: [Customer] = []
  
  init(numberOfBankers: Int) throws {
    self.operationQueue = OperationQueue()
    try self.customers = CustomerMaker().makeCustomer(count: Int.random(in: 10...30))
    operationQueue.maxConcurrentOperationCount = numberOfBankers
  }
  
  func inputCustomersIntoOperationQueue() -> Int {
    let totalCustomerCount = customers.count
    operationQueue.addOperations(customers.map { $0.showTask() }, waitUntilFinished: true)
    return totalCustomerCount
  }
}
