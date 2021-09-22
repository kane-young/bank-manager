//
//  BankManager.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/09/21.
//

import Foundation

final class BankManager {
  private enum Comment {
    static let preTask: (_: Customer) -> String = { customer in
      return "\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 시작"
    }
    static let postTask: (_: Customer) -> String = { customer in
      return "\(customer.ticketNumber)번 \(customer.grade)고객 \(customer.taskType) 업무 완료"
    }
    static let preHeadQuarterTask: (_: Customer) -> String = { customer in
      return "\(customer.ticketNumber)번 \(customer.grade)고객 대출 심사 시작"
    }
    static let postHeadQuarterTask: (_: Customer) -> String = { customer in
      return "\(customer.ticketNumber)번 \(customer.grade)고객 대출 심사 완료"
    }
  }
  
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
    let tasks = customers.map { $0.task() }
    let bankTasks = configureTasksHandler(tasks)
    return bankTasks
  }
  
  private func configureTasksHandler(_ bankTasks: [BankTask]) -> [Operation] {
    let operations = bankTasks.map { bankTask -> Operation in
      bankTask.preHandler = {
        print(Comment.preTask($0))
      }
      bankTask.completionHandler = {
        print(Comment.postTask($0))
      }
      if let loanTask = bankTask as? LoanTask {
        loanTask.preHeadQuarterTaskHandler = {
          print(Comment.preHeadQuarterTask($0))
        }
        loanTask.completionHeadQuarterTaskHandler = {
          print(Comment.postHeadQuarterTask($0))
        }
        return loanTask
      }
      return bankTask
    }
    return operations
  }
}
