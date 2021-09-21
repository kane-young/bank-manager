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
  
  func process(customer: Customer) {
    let task = HeadQuarterTask(customer: customer)
    task.preHandler = { customer in
      print("\(customer.ticketNumber)번 \(customer.grade)고객 대출 심사 시작")
    }
    task.completionHandler = { customer in
      print("\(customer.ticketNumber)번 \(customer.grade)고객 대출 심사 완료")
    }
    operationQueue.addOperations([task] , waitUntilFinished: true)
  }
}
