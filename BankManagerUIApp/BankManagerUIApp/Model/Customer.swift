//
//  Customer.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class Customer {
  private let ticketNumber: Int
  private let grade: CustomerGrade
  private let taskType: TaskType
  
  private var isProceessed: Bool = false
  private var isProcessLoanJudge: Bool = false

  init(ticketNumber: Int, grade: CustomerGrade, taskType: TaskType) {
    self.ticketNumber = ticketNumber
    self.grade = grade
    self.taskType = taskType
  }
  
  func progressTask() {
    isProceessed = true
  }
  
  func progressHeadQuarterTask() {
    isProcessLoanJudge = true
  }
  
  func priority() -> Operation.QueuePriority {
    return grade.queuePriority
  }
  
  func isloanTasking() -> Bool {
    if taskType == .loan {
      return true
    }
    return false
  }
  
  func taskTime() -> Double {
    return taskType.taskTime
  }
}
