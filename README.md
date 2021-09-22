# 🏦 은행 창구 앱

(with [KangKyung](https://github.com/KangKyung))

📅 프로젝트 진행 기간 : 2021-04-26 ~ 2021-05-07 / 리팩토링 : 2021-09-18 ~ 2021-09-22

- [Ground Rule](https://github.com/KangKyung/ios-bank-manager/blob/main/Ground%20Rule.md)

<br>

## 1. Overview

실제 은행처럼 여러 개의 은행원들이 여러 고객의 업무를 동시에 처리하도록 앱을 구현함

Thread의 개념을 이해하고 `Operation` / `OperationQueue` / 비동기 프로그래밍에 대한 개념을 활용

Console App 으로 무작위로 생성되는 고객들이 `은행 개점`과 동시에 업무처리 됨

<br>

### Flow Chart

<img width="278" alt="스크린샷 2021-09-22 오후 3 37 09" src="https://user-images.githubusercontent.com/64566207/134294594-de00cdee-da99-4a38-afc9-646c20dcac77.png">

<br>

### UML - Class Diagram

<img width="800" alt="스크린샷 2021-09-22 오후 5 49 57" src="https://user-images.githubusercontent.com/64566207/134312943-71a8190b-608b-478f-a7c8-089b5804d9ec.png">

<br>

### 실행 화면

<img src="https://user-images.githubusercontent.com/38858863/125564546-06777969-984b-4c25-bdc2-623c5e8fd326.gif" width="500">l	

<br>

<br>

## 2. 설계 및 구현

<img width="800" alt="스크린샷 2021-09-22 오후 5 49 57" src="https://user-images.githubusercontent.com/64566207/134312943-71a8190b-608b-478f-a7c8-089b5804d9ec.png">

<br>

### 비동기 작업 객체화

`비동기 작업` 을 객체화 시키기 위해서 `Operation` 을 상속 받은 `BankTask` 를 생성, 고객의 grade에 따라 업무 처리 우선권을 주기 위해서 `Operation` 의 프로퍼티 `queuePriority` 를 지정

```swift
class BankTask: Operation {
  let customer: Customer
  var preHandler: ((_: Customer) -> Void)?
  var completionHandler: ((_: Customer) -> Void)?

  init(customer: Customer) {
    self.customer = customer
    super.init()
    self.queuePriority = customer.priority()
  }
}
```

<br>

### 은행 업무의 종류를 구분하기 위해서 BankTask를 상속한 객체 생성

<img width="700" alt="스크린샷 2021-09-22 오후 5 46 16" src="https://user-images.githubusercontent.com/64566207/134317170-286c79bd-60e8-4e31-a64c-a0e53da750be.png">

예금업무, 대출업무, 본사에서의 대출 심사 업무를 구체화 시키기 위해서 `BankTask` 를 상속한 객체 생성

같은 인터페이스를 공유하고 있기에 `BankTask` 라는 부모 클래스를 생성하고, 상속을 통한 구체화

또한 일반화 개념을 활용해서 아래 `Operation` 들을 `BankTask` 로 반환 타입으로 활용

```swift
struct Customer {
  let grade: CustomerGrade
  //...
  func task() -> BankTask {
    switch taskType {
    case .deposit:
      return DepositTask(customer: self)
    case .loan:
      return LoanTask(customer: self)
    }
  }
	//...
}

```

<br>

### 본사 대출 심사 - 고객 한명씩 수행

본사에서의 대출 심사는 한번에 한명씩만 이뤄지기 때문에, `OperationQueue` 를 Serial Queue로 설정

-> `OperationQueue` 의 `maxConcurrentOperationCount` 프로퍼티 1 할당

 본사의 경우 하나의 객체만 존재해야 되기 때문에 

-> singleTon 디자인 패턴을 활용

```swift
final class HeadQuarter {
  static let shared: HeadQuarter = HeadQuarter()
  private var operationQueue = OperationQueue()
  
  private init() {
    operationQueue.maxConcurrentOperationCount = 1
  }
  
  func process(customer: Customer,
               preHandler: ((_: Customer) -> Void)?,
               completionHandler: ((_: Customer) -> Void)?) {
    let task = HeadQuarterTask(customer: customer)
    task.preHandler = preHandler
    task.completionHandler = completionHandler
    operationQueue.addOperations([task] , waitUntilFinished: true)
  }
}
```

<br>

### 작업 전후 수행할 일들을 지정하기 위해서 "handler" 클로저 활용

이를 통해서 대출 업무를 보러온 고객의 경우

"1번 VVIP 고객 대출 업무 시작" -> 0.3초 delay ->

"1번 VVIP 고객 대출 심사 시작" -> 0.5초 delay -> 

"1번 VVIP 고객 대출 심사 완료" -> 0.3초 delay -> "1번 VVIP 고객 대출 업무 완료"

를 수행하도록 지정할 수 있다

```swift
class BankTask: Operation {
  let customer: Customer
  var preHandler: ((_: Customer) -> Void)?
  var completionHandler: ((_: Customer) -> Void)?
	//...
}

class LoanTask: BankTask {
  var preHeadQuarterTaskHandler: ((_: Customer) -> Void)?
  var completionHeadQuarterTaskHandler: ((_: Customer) -> Void)?
  
  override func main() {
    let workingTime: Double = self.customer.taskType.taskTime
    preHandler?(customer)
    Thread.sleep(forTimeInterval: workingTime)
    HeadQuarter.shared.process(customer: customer,
                               preHandler: preHeadQuarterTaskHandler,
                               completionHandler: completionHeadQuarterTaskHandler)
    Thread.sleep(forTimeInterval: workingTime)
    completionHandler?(customer)
  }
}

class HeadQuarterTask: BankTask {
  override func main() {
    preHandler?(customer)
    Thread.sleep(forTimeInterval: 0.5)
    completionHandler?(customer)
  }
}
```

<br>

### Unit Test 진행

`비동기 작업` 에 대한 Unit Test는 `XCTest` 의 `XCTestExpectation` 를 활용해서 해당 `expectation` 이 비동기 작업이 끝날 때 `fulfull()` 되는 것을 기다리는 방법으로 진행

```swift
//대출심사과정 0.5초
  //- timeout: 0.5초 지정시 testFail
  func test_본사_대출고객심사_비동기테스트() {
    //given
    let expectation = XCTestExpectation(description: "대출심사완료")
    //when
    OperationQueue().addOperation { [weak self] in
      self?.headQuarter.process(customer: Customer(order: 1, grade: .vip, taskType: .deposit),
                                preHandler: nil,
                                completionHandler: { _ in
        //then
        expectation.fulfill()
      })
    }
    wait(for: [expectation], timeout: 0.51)
  }
```

위 테스트의 경우 0.5초가 걸리는 작업인 만큼 0.51초를 기다리면서 해당 `expectation` 이 수행되었는지를 확인하는 방법으로 진행합니다

<img width="683" alt="스크린샷 2021-09-22 오후 9 26 46" src="https://user-images.githubusercontent.com/64566207/134343403-82a9eb72-6f6a-4ca2-98b1-96d9eb625cce.png">

<br>

<br>

## 3. 고민했던 점

[Step1 PR - with 하이디](https://github.com/yagom-academy/ios-bank-manager/pull/30)

[Step2 PR - with 하이디](https://github.com/yagom-academy/ios-bank-manager/pull/49)

[Step3 PR - with 하이디](https://github.com/yagom-academy/ios-bank-manager/pull/60)

### 작업을 Operation을 상속하여 객체화

초기 설계 단계에서는 `Operation` 타입을 따로 정의하지 않고, 클로저를 통해 `OperationQueue` 에 작업을 추가하였습니다.

하지만, 재사용성이 매우 떨어지는 문제와 `BankManager`가 `고객 추가`, `Operation` 구체화, 업무 진행중인 고객에 대한 Notification 발송 등의 여러 역할을 수행하는 문제가 발생하여, `Operation` 타입 생성을 통해 해당 문제를 해결하려고 하였습니다.

코드 리팩토링을 통해서 `Operation` 수행 초기, 혹은 이후 수행해야되는 `closure`를  `handler` 를 통해서 주입할 수 있는 등 더욱 유연한 구조가 되었습니다

**이전 코드**

```swift
func process(_ customers: [Int:Customer]) {
  //...
  operationQueue.addOperation {
    workableBanker?.process(customer)

    self.bankers[counterNumber] = workableBanker
    self.totalCompletedCustomer += 1
  }
}

```

**리팩토링 이후 코드**

```swift
class BankTask: Operation {
  let customer: Customer
  var preHandler: ((_: Customer) -> Void)?
  var completionHandler: ((_: Customer) -> Void)?

  init(customer: Customer) {
    self.customer = customer
    super.init()
    self.queuePriority = customer.priority()
  }
}
```

<br>

### 비동기 작업에 대한 테스트

초기에 비동기 테스트를 하기 위해서 비동기 작업이 끝나는 시간까지 `sleep` 을 하고, 이후에 결과 값을 비교하는 방법으로 진행하였습니다. 하지만, 해당 방법을 수행해도 `totalCustomerCount` 는 0으로 변하지 않는 문제가 발생하였습니다.

```swift
func test_고객4명_은행업무_처리후_totalCustomer비교() {
	bank.open()
  OperationQueue().addOperation {
    sleep(3)
    XCTAssertEqual(self.bankManager.showTotalCompletedCustomer(), 4)
  }
}
```

이후, 리뷰어에게 `expectation(description:)`, `fulfill()`, `waitForExpectations(timeout:)` 키워드를 추천받아, [Raywenderlich tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial#toc-anchor-009) 를 참고하여 테스트를 수행했습니다

`Operation`을 객체화 시켜 `handler` 를 직접 생성하기도 하였으며, 혹은 이미 가지고 있는 인스턴스 프로퍼티 `completionBlock` 을 활용해서 `expectation.fulfill()` 을 실행시켰습니다

```swift
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
```

<br>

### Customer의 Priority 지정하는 방법 고민

초기 설계한 모델의 경우 `Operation` 객체화가 이뤄지지 않아 `queuePriority` 설정이 불가능 했다. 그래서 `Customer` 의 `grade` 를 통해 분류하고, 업무 수행을 할 때마다 높은 순위에 있는 `grade` 의 `Operation` 이 있는지 끊임없이 확인해야 했다. 하지만, 객체화 이후 이 부분은 `queuePriority` 를 통해 매우 간단해졌으며, 사실상 아래 사진의 가운데 두 `Operation Queue` 가 필요없어진 것을 확인할 수 있다

**변경 전 Operation Queue Flow**

<img src="https://user-images.githubusercontent.com/64566207/117004470-1010e200-ad21-11eb-81f3-614cc903ded9.png" width="700">

**변경 후 Operation Queue Flow**

<img src="https://user-images.githubusercontent.com/64566207/117004510-199a4a00-ad21-11eb-91ca-40ffbcd74368.png" width="700">

<br>

<br>

## 학습 키워드

- Dispatch / DispatchQueue
- Operation / OperationQueue
- Semaphore 공유 자원 문제(경쟁 상황)
- 교착 상태 (Dead Lock)
- 비동기 프로그래밍 , 동기 프로그래밍
- 비동기 프로그래밍 Unit Test, XCTestExpectation, fulfill() 

<br>

### 블로그 포스팅 - Kane

[GCD-Operation 학습](https://velog.io/@leeyoungwoozz/TIL-2021.04.30-Fri)

[GCD-Operation 심화 학습](https://velog.io/@leeyoungwoozz/iOS-GCD-Operation)