//
//  BankError.swift
//  BankManagerConsoleApp
//
//  Created by 이영우 on 2021/05/04.
//
//

import Foundation

enum BankError: Error, CustomStringConvertible {
  case invalidNumberOfCustomers
  case invalidInput
}

extension BankError {
  var description: String {
    switch self {
    case .invalidNumberOfCustomers:
      return "고객의 랜덤 수가 유효하지 않습니다"
    case .invalidInput:
      return "올바른 입력이 아닙니다"
    }
  }
}
