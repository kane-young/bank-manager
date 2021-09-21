//
//  HeadQuarterTask.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class HeadQuarterTask: Operation {
  private let customer: Customer
  private let firstHandler: (_ : Customer) -> ()
  private let completionHandler: (_ : Customer) -> ()
  
  init(customer: Customer,
       firstHandler: @escaping (_ : Customer) -> (),
       completionHandler: @escaping (_ : Customer) -> ()) {
    self.customer = customer
    self.firstHandler = firstHandler
    self.completionHandler = completionHandler
  }
  
  override func main() {
    firstHandler(customer)
    Thread.sleep(forTimeInterval: 0.5)
    completionHandler(customer)
  }
}
