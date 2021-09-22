//
//  LoanTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/09/21.
//

import Foundation

class LoanTask: BankTask {
  var preHeadQuarterTaskHandler: ((_: Customer) -> Void)?
  var completionHeadQuarterTaskHandler: ((_: Customer) -> Void)?
  
  override func main() {
    let workingTime: Double = self.customer.taskType.taskTime
    preHandler?(customer)
    Thread.sleep(forTimeInterval: workingTime)
    HeadQuarter.shared.process(customer: customer,
                               preHandler: preHeadQuarterTaskHandler,
                               completionHandler: completionHeadQuarterTaskHandler)
    Thread.sleep(forTimeInterval: workingTime)
    completionHandler?(customer)
  }
}
