//
//  BankTask.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class BankTask: Operation {
  private let customer: Customer
  private let headQuarter: HeadQuarter = HeadQuarter.shared
  private let firstHandler: ((_: Customer) -> ())
  private let midHandler: ((_: Customer) -> ())
  private let completionHandler: ((_: Customer) -> ())
  
  init(customer: Customer,
       firstHandler: @escaping (_ : Customer) -> (),
       midHandler: @escaping (_ : Customer) -> () = { _ in },
       completionHandler: @escaping (_ : Customer) -> ()) {
    self.customer = customer
    self.firstHandler = firstHandler
    self.midHandler = midHandler
    self.completionHandler = completionHandler
    super.init()
    self.queuePriority = self.customer.priority()
  }
  
  override func main() {
    if isCancelled { return }
    let workingTime: Double = self.customer.taskTime()
    firstHandler(customer)
    Thread.sleep(forTimeInterval: workingTime)
    if customer.isloanTasking() {
      headQuarter.evaluate(customer: customer,
                           firstCompletion: midHandler,
                           completionHandler: completionHandler)
    } else {
      completionHandler(customer)
    }
  }
}
