//
//  CustomerMaker.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class CustomerMaker {
  static var ticketNumber: Int = 1
  
  func makeCustomer(count: Int) throws -> [Customer] {
    var customers: [Customer] = []
    for number in CustomerMaker.ticketNumber...CustomerMaker.ticketNumber + count {
      let customer = try randomCustomer(number: number)
      customers.append(customer)
    }
    return customers
  }
  
  private func randomCustomer(number: Int) throws -> Customer {
    guard let grade = CustomerGrade.random() else {
      throw BankError.failMakeRandomGradeType
    }
    
    guard let task = TaskType.random() else {
      throw BankError.failMakeRandomTaskType
    }
    return Customer(ticketNumber: number, grade: grade, taskType: task)
  }
}
