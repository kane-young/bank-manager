//
//  BankError.swift
//  BankManagerUIApp
//
//  Created by 이영우 on 2021/09/16.
//

import Foundation

enum BankError: Error {
  case invalidNumberOfCustomers
  case failMakeRandomGradeType
  case failMakeRandomTaskType
}

extension BankError: CustomStringConvertible {
  var description: String {
    switch self {
    case .invalidNumberOfCustomers:
      return "고객의 랜덤 수가 유효하지 않습니다"
    case .failMakeRandomGradeType:
      return "랜덤 고객등급 생성에 실패했습니다"
    case .failMakeRandomTaskType:
      return "랜덤 고객업무 타입 생성에 실패했습니다"
    }
  }
}
