//
//  HeadQuarterTask.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/05/06.
//

import Foundation

class HeadQuarterTask: BankTask {
  static let time: Double = 0.5
  
  override init(customer: Customer) {
    super.init(customer: customer)
    self.queuePriority = .normal
  }
  
  override func main() {
    preHandler?(customer)
    Thread.sleep(forTimeInterval: HeadQuarterTask.time)
    completionHandler?(customer)
  }
}
