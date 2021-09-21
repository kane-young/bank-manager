//
//  HeadQuarterTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/05/06.
//

import Foundation

class HeadQuarterTask: BankTask {
  override init(customer: Customer) {
    super.init(customer: customer)
    self.queuePriority = .normal
  }
  
  override func main() {
    preHandler?(customer)
    Thread.sleep(forTimeInterval: 0.5)
    completionHandler?(customer)
  }
}
