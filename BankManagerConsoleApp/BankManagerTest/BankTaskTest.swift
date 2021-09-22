//
//  BankTaskTest.swift
//  BankManagerTest
//
//  Created by 이영우 on 2021/05/07.
//

import XCTest

class BankTaskTest: XCTestCase {
  var bankDepositTask: BankTask!
  var bankLoanTask: BankTask!
  
  override func setUpWithError() throws {
    bankDepositTask = DepositTask(customer: Customer(order: 1, grade: .vip, taskType: .deposit))
    bankLoanTask = LoanTask(customer: Customer(order: 2, grade: .vvip, taskType: .loan))
  }
  
  override func tearDownWithError() throws {
    bankDepositTask = nil
    bankLoanTask = nil
  }
  
  ///예금작업시 0.7초 소요
  ///- timeout: 0.7초시 testFail발생
  func test_Deposit비동기_시간경과_테스트() {
    //given
    let expectation = XCTestExpectation(description: "예금 완료")
    //when
    bankDepositTask.completionHandler = { _ in
      //then
      expectation.fulfill()
    }
    OperationQueue().addOperation(bankDepositTask)
    
    //예금작업 0.7초 소요
    wait(for: [expectation], timeout: 0.71)
  }
  
  ///대출작업시 1.1초 소요
  ///- timeout: 1.1초시 testFail발생
  func test_Loan비동기_시간경과_테스트() {
    //given
    let expectation = XCTestExpectation(description: "대출 완료")
    //when
    bankLoanTask.completionHandler = { _ in
      //then
      expectation.fulfill()
    }
    OperationQueue().addOperation(bankLoanTask)
    
    //대출 업무 총 1.1초 소요
    wait(for: [expectation], timeout: 1.2)
  }
}
