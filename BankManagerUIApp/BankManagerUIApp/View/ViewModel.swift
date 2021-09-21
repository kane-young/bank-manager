//
//  ViewModel.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/19.
//

import Foundation

final class ViewModel {
  private let bank: Bank
  private var firstHandler: ((Customer) -> Void)?
  private var secondHandler: ((Customer) -> Void)?
  private var thirdHandler: ((Customer) -> Void)?

  init(bankerCount: Int) {
    self.bank = Bank(bankerCount: bankerCount)
  }
  
  func addCustomers(count: Int) {
    
  }
  
  func bindFirst(_ handler: @escaping (Customer) -> Void) {
    self.firstHandler = handler
  }
  
  func bindSecond(_ handler: @escaping (Customer) -> Void) {
    self.secondHandler = handler
  }
  
  func bindCompletion(_ handler: @escaping (Customer) -> Void) {
    self.thirdHandler = handler
  }
}
