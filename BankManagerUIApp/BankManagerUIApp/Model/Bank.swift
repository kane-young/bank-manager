//
//  Bank.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

final class Bank {
  private let bankerNumber = 3
  private var bankManager: BankManager
  private var totalCustomerCount: Int = 0
  
  init() throws {
    try self.bankManager = BankManager(numberOfBankers: bankerNumber)
  }

  func open() {
    let openTime = CFAbsoluteTimeGetCurrent()
    self.totalCustomerCount = bankManager.inputCustomersIntoOperationQueue()
    close(from: openTime, total: self.totalCustomerCount)
  }
  
  private func close(from openTime: CFAbsoluteTime, total: Int) {
    let closeTime = CFAbsoluteTimeGetCurrent()
    let totalWorkTime = round((closeTime - openTime) * 100) / 100
    
    let complateString = """
    업무가 마감되었습니다.
    오늘 업무를 처리한 고객은 총 \(total)명이며,
    총 업무 시간은 \(totalWorkTime)초입니다.
    """
    print(complateString)
  }
}
