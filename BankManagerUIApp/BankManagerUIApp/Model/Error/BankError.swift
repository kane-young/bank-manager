//
//  BankError.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

enum BankError: Error {
  case invalidNumberOfCustomers
}

extension BankError: CustomStringConvertible {
  var description: String {
    switch self {
    case .invalidNumberOfCustomers:
      return "고객의 랜덤 수가 유효하지 않습니다"
    }
  }
}
