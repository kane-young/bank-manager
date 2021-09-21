//
//  DepositTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/09/21.
//

import Foundation

class DepositTask: BankTask {
  override func main() {
    let workingTime: Double = self.customer.taskType.taskTime
    preHandler?(customer)
    Thread.sleep(forTimeInterval: workingTime)
    completionHandler?(customer)
  }
}
