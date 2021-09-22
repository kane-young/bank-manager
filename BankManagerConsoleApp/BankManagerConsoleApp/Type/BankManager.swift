//
//  BankManager.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/09/21.
//

import Foundation

final class BankManager {
  private var queue = OperationQueue()
  
  init(bankerCount: Int) {
    self.queue.maxConcurrentOperationCount = bankerCount
  }
  
  func insertCustomer(count: Int,
                      completion: @escaping (_: Int, _: Double) -> Void) {
    let openTime = CFAbsoluteTimeGetCurrent()
    var customers: [Customer]
    
    do {
      customers = try CustomerMaker().makeCustomer(count: count)
    } catch {
      fatalError(error.localizedDescription)
    }
    let tasks = tasks(customers)
    self.queue.addOperations(tasks, waitUntilFinished: true)
    
    let closeTime = CFAbsoluteTimeGetCurrent()
    let totalTime = round((closeTime - openTime) * 100) / 100
    completion(customers.count, totalTime)
  }
    
  private func tasks(_ customers: [Customer]) -> [Operation] {
    let tasks = customers.map { $0.task() }.map { operation -> Operation in
      operation.preHandler = { customer in
        print("\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 시작")
      }
      operation.completionHandler = { customer in
        print("\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 완료")
      }
      if let operation = operation as? LoanTask {
        operation.preHeadQuarterTaskHandler = {
          print("\($0.ticketNumber)번 \($0.grade)고객 대출 심사 시작")
        }
        operation.completionHeadQuarterTaskHandler = {
          print("\($0.ticketNumber)번 \($0.grade)고객 대출 심사 완료")
        }
        return operation
      }
      return operation
    }
    return tasks
  }
}
