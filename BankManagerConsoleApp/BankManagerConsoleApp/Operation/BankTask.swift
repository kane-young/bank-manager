//
//  BankTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/05/04.
//

import Foundation

class BankTask: Operation {
  let customer: Customer
  var preHandler: ((_: Customer) -> Void)?
  var completionHandler: ((_: Customer) -> Void)?

  init(customer: Customer) {
    self.customer = customer
    super.init()
    self.queuePriority = customer.priority()
  }
}
