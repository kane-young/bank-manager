//
//  LoanTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/09/21.
//

import Foundation

class LoanTask: BankTask {
  override func main() {
    let workingTime: Double = self.customer.taskType.taskTime
    preHandler?(customer)
    Thread.sleep(forTimeInterval: workingTime)
    HeadQuarter.shared.process(customer: customer)
    Thread.sleep(forTimeInterval: workingTime)
    completionHandler?(customer)
  }
}
