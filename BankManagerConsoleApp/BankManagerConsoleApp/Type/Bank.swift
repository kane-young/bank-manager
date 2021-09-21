//
//  Bank.swift
//  BankManagerConsoleApp
//
//  Created by 강경 on 2021/04/26.
//

import Foundation

struct Bank {
  private let bankManager: BankManager
  
  init(numberOfBanker: Int) {
    self.bankManager = BankManager(bankerCount: numberOfBanker)
  }
  
  private enum Menu: CustomStringConvertible {
    static let selection: String = "1: 은행 개점\n2: 종료 \n입력: "
    case open
    case exit
    
    var description: String {
      switch self {
      case .open:
        return "1"
      case .exit:
        return "2"
      }
    }
  }
  
  private func printMenu() {
    print(Menu.selection, terminator: "")
  }
  
  private func selectMenu() throws -> Menu{
    guard let userInput = readLine() else {
      throw BankError.invalidInput
    }
    
    switch userInput {
    case "1":
      return Menu.open
    case "2":
      return Menu.exit
    default:
      throw BankError.invalidInput
    }
  }
  
  func open() {
    outer: while true {
      printMenu()
      var menu: Menu
      do {
        menu = try selectMenu()
      } catch {
        print(error)
        continue
      }
      
      switch menu {
      case .open:
        bankManager.insertCustomer(count: 10)
      case .exit:
        break outer
      }
    }
  }
}
