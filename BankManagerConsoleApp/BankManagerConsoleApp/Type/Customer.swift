//
//  Customer.swift
//  BankManagerConsoleApp
//
//  Created by 강경 on 2021/04/26.
//

import Foundation

struct Customer {
  let ticketNumber: Int
  let grade: CustomerGrade
  let taskType: TaskType

  init(order orderNumber: Int, grade: CustomerGrade, taskType: TaskType) {
    self.ticketNumber = orderNumber
    self.grade = grade
    self.taskType = taskType
  }

  func task() -> BankTask {
    switch taskType {
    case .deposit:
      return DepositTask(customer: self)
    case .loan:
      return LoanTask(customer: self)
    }
  }
  
  func priority() -> Operation.QueuePriority {
    return grade.queuePriority
  }
}
