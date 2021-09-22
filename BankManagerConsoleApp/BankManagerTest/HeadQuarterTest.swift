//
//  HeadQuarterTest.swift
//  BankManagerTest
//
//  Created by 이영우 on 2021/05/07.
//

import XCTest

class HeadQuarterTest: XCTestCase {
  var headQuarter: HeadQuarter!
  
  override func setUpWithError() throws {
    headQuarter = HeadQuarter.shared
  }
  
  override func tearDownWithError() throws {
    headQuarter = nil
  }
  
  //대출심사과정 0.5초
  //- timeout: 0.5초 지정시 testFail
  func test_본사_대출고객심사_비동기테스트() {
    //given
    let expectation = XCTestExpectation(description: "대출심사완료")
    //when
    OperationQueue().addOperation { [weak self] in
      self?.headQuarter.process(customer: Customer(order: 1, grade: .vip, taskType: .deposit), preHandler: nil, completionHandler: { _ in
        //then
        expectation.fulfill()
      })
    }
    
    wait(for: [expectation], timeout: 0.51)
  }
}
