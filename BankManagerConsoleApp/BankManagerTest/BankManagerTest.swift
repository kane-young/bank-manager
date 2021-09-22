//
//  BankManagerTest.swift
//  BankManagerTest
//
//  Created by 이영우 on 2021/05/03.
//

import XCTest

class BankManagerTest: XCTestCase {
  var bankManager: BankManager!
  
  override func setUpWithError() throws {
    bankManager = BankManager(bankerCount: 1)
  }
  
  override func tearDownWithError() throws {
    bankManager = nil
  }
  
  ///10명 고객 최대 업무 걸리는 시간 11초
  ///대출 - 총 1.1초
  ///예금 - 총 0.7초
  func test_when_bankManager에서_고객10명_은행원1명_insert할시_최대11초소요() {
    let expectation = XCTestExpectation(description: "Customers 업무 완료")
    OperationQueue().addOperation { [weak self] in
      self?.bankManager.insertCustomer(count: 10, completion: { _,n_  in
        expectation.fulfill()
      })
    }
    wait(for: [expectation], timeout: 11)
  }
}
