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
  
  func insertCustomer(count: Int) {
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
    close(totalCustomerCount: customers.count, totalTime: totalTime)
  }
    
  private func tasks(_ customers: [Customer]) -> [Operation] {
    let tasks = customers.map { $0.task() }.map { operation -> Operation in
      operation.preHandler = { customer in
        print("\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 시작")
      }
      operation.completionHandler = { customer in
        print("\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 완료")
      }
      return operation
    }
    return tasks
  }
  
  private func close(totalCustomerCount: Int, totalTime: Double) {
    let complateString = """
    업무가 마감되었습니다.
    오늘 업무를 처리한 고객은 총 \(totalCustomerCount)명이며,
    총 업무 시간은 \(totalTime)초입니다.
    """
    print(complateString)
  }
}
