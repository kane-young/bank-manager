# π¦ μν μ°½κ΅¬ μ±

(with [KangKyung](https://github.com/KangKyung))

π νλ‘μ νΈ μ§ν κΈ°κ° : 2021-04-26 ~ 2021-05-07 / λ¦¬ν©ν λ§ : 2021-09-18 ~ 2021-09-22

- [Ground Rule](https://github.com/KangKyung/ios-bank-manager/blob/main/Ground%20Rule.md)

<br>

## 1. Overview

μ€μ  μνμ²λΌ μ¬λ¬ κ°μ μνμλ€μ΄ μ¬λ¬ κ³ κ°μ μλ¬΄λ₯Ό λμμ μ²λ¦¬νλλ‘ μ±μ κ΅¬νν¨

Threadμ κ°λμ μ΄ν΄νκ³  `Operation` / `OperationQueue` / λΉλκΈ° νλ‘κ·Έλλ°μ λν κ°λμ νμ©

Console App μΌλ‘ λ¬΄μμλ‘ μμ±λλ κ³ κ°λ€μ΄ `μν κ°μ `κ³Ό λμμ μλ¬΄μ²λ¦¬ λ¨

<br>

### Flow Chart

<img width="278" alt="μ€ν¬λ¦°μ· 2021-09-22 μ€ν 3 37 09" src="https://user-images.githubusercontent.com/64566207/134294594-de00cdee-da99-4a38-afc9-646c20dcac77.png">

<br>

### UML - Class Diagram

<img width="800" alt="μ€ν¬λ¦°μ· 2021-09-22 μ€ν 5 49 57" src="https://user-images.githubusercontent.com/64566207/134312943-71a8190b-608b-478f-a7c8-089b5804d9ec.png">

<br>

### μ€ν νλ©΄

<img src="https://user-images.githubusercontent.com/38858863/125564546-06777969-984b-4c25-bdc2-623c5e8fd326.gif" width="500">l	

<br>

<br>

## 2. μ€κ³ λ° κ΅¬ν

<img width="800" alt="μ€ν¬λ¦°μ· 2021-09-22 μ€ν 5 49 57" src="https://user-images.githubusercontent.com/64566207/134312943-71a8190b-608b-478f-a7c8-089b5804d9ec.png">

<br>

### λΉλκΈ° μμ κ°μ²΄ν

`λΉλκΈ° μμ` μ κ°μ²΄ν μν€κΈ° μν΄μ `Operation` μ μμ λ°μ `BankTask` λ₯Ό μμ±, κ³ κ°μ gradeμ λ°λΌ μλ¬΄ μ²λ¦¬ μ°μ κΆμ μ£ΌκΈ° μν΄μ `Operation` μ νλ‘νΌν° `queuePriority` λ₯Ό μ§μ 

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

### μν μλ¬΄μ μ’λ₯λ₯Ό κ΅¬λΆνκΈ° μν΄μ BankTaskλ₯Ό μμν κ°μ²΄ μμ±

<img width="700" alt="μ€ν¬λ¦°μ· 2021-09-22 μ€ν 5 46 16" src="https://user-images.githubusercontent.com/64566207/134317170-286c79bd-60e8-4e31-a64c-a0e53da750be.png">

μκΈμλ¬΄, λμΆμλ¬΄, λ³Έμ¬μμμ λμΆ μ¬μ¬ μλ¬΄λ₯Ό κ΅¬μ²΄ν μν€κΈ° μν΄μ `BankTask` λ₯Ό μμν κ°μ²΄ μμ±

κ°μ μΈν°νμ΄μ€λ₯Ό κ³΅μ νκ³  μκΈ°μ `BankTask` λΌλ λΆλͺ¨ ν΄λμ€λ₯Ό μμ±νκ³ , μμμ ν΅ν κ΅¬μ²΄ν

λν μΌλ°ν κ°λμ νμ©ν΄μ μλ `Operation` λ€μ `BankTask` λ‘ λ°ν νμμΌλ‘ νμ©

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

### λ³Έμ¬ λμΆ μ¬μ¬ - κ³ κ° νλͺμ© μν

λ³Έμ¬μμμ λμΆ μ¬μ¬λ νλ²μ νλͺμ©λ§ μ΄λ€μ§κΈ° λλ¬Έμ, `OperationQueue` λ₯Ό Serial Queueλ‘ μ€μ 

-> `OperationQueue` μ `maxConcurrentOperationCount` νλ‘νΌν° 1 ν λΉ

 λ³Έμ¬μ κ²½μ° νλμ κ°μ²΄λ§ μ‘΄μ¬ν΄μΌ λκΈ° λλ¬Έμ 

-> singleTon λμμΈ ν¨ν΄μ νμ©

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

### μμ μ ν μνν  μΌλ€μ μ§μ νκΈ° μν΄μ "handler" ν΄λ‘μ  νμ©

μ΄λ₯Ό ν΅ν΄μ λμΆ μλ¬΄λ₯Ό λ³΄λ¬μ¨ κ³ κ°μ κ²½μ°

"1λ² VVIP κ³ κ° λμΆ μλ¬΄ μμ" -> 0.3μ΄ delay ->

"1λ² VVIP κ³ κ° λμΆ μ¬μ¬ μμ" -> 0.5μ΄ delay -> 

"1λ² VVIP κ³ κ° λμΆ μ¬μ¬ μλ£" -> 0.3μ΄ delay -> "1λ² VVIP κ³ κ° λμΆ μλ¬΄ μλ£"

λ₯Ό μννλλ‘ μ§μ ν  μ μλ€

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

### Unit Test μ§ν

`λΉλκΈ° μμ` μ λν Unit Testλ `XCTest` μ `XCTestExpectation` λ₯Ό νμ©ν΄μ ν΄λΉ `expectation` μ΄ λΉλκΈ° μμμ΄ λλ  λ `fulfull()` λλ κ²μ κΈ°λ€λ¦¬λ λ°©λ²μΌλ‘ μ§ν

```swift
//λμΆμ¬μ¬κ³Όμ  0.5μ΄
  //- timeout: 0.5μ΄ μ§μ μ testFail
  func test_λ³Έμ¬_λμΆκ³ κ°μ¬μ¬_λΉλκΈ°νμ€νΈ() {
    //given
    let expectation = XCTestExpectation(description: "λμΆμ¬μ¬μλ£")
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

μ νμ€νΈμ κ²½μ° 0.5μ΄κ° κ±Έλ¦¬λ μμμΈ λ§νΌ 0.51μ΄λ₯Ό κΈ°λ€λ¦¬λ©΄μ ν΄λΉ `expectation` μ΄ μνλμλμ§λ₯Ό νμΈνλ λ°©λ²μΌλ‘ μ§νν©λλ€

<img width="683" alt="μ€ν¬λ¦°μ· 2021-09-22 μ€ν 9 26 46" src="https://user-images.githubusercontent.com/64566207/134343403-82a9eb72-6f6a-4ca2-98b1-96d9eb625cce.png">

<br>

<br>

## 3. κ³ λ―Όνλ μ 

[Step1 PR - with νμ΄λ](https://github.com/yagom-academy/ios-bank-manager/pull/30)

[Step2 PR - with νμ΄λ](https://github.com/yagom-academy/ios-bank-manager/pull/49)

[Step3 PR - with νμ΄λ](https://github.com/yagom-academy/ios-bank-manager/pull/60)

### μμμ Operationμ μμνμ¬ κ°μ²΄ν

μ΄κΈ° μ€κ³ λ¨κ³μμλ `Operation` νμμ λ°λ‘ μ μνμ§ μκ³ , ν΄λ‘μ λ₯Ό ν΅ν΄ `OperationQueue` μ μμμ μΆκ°νμμ΅λλ€.

νμ§λ§, μ¬μ¬μ©μ±μ΄ λ§€μ° λ¨μ΄μ§λ λ¬Έμ μ `BankManager`κ° `κ³ κ° μΆκ°`, `Operation` κ΅¬μ²΄ν, μλ¬΄ μ§νμ€μΈ κ³ κ°μ λν Notification λ°μ‘ λ±μ μ¬λ¬ μ­ν μ μννλ λ¬Έμ κ° λ°μνμ¬, `Operation` νμ μμ±μ ν΅ν΄ ν΄λΉ λ¬Έμ λ₯Ό ν΄κ²°νλ €κ³  νμμ΅λλ€.

μ½λ λ¦¬ν©ν λ§μ ν΅ν΄μ `Operation` μν μ΄κΈ°, νΉμ μ΄ν μνν΄μΌλλ `closure`λ₯Ό  `handler` λ₯Ό ν΅ν΄μ μ£Όμν  μ μλ λ± λμ± μ μ°ν κ΅¬μ‘°κ° λμμ΅λλ€

**μ΄μ  μ½λ**

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

**λ¦¬ν©ν λ§ μ΄ν μ½λ**

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

### λΉλκΈ° μμμ λν νμ€νΈ

μ΄κΈ°μ λΉλκΈ° νμ€νΈλ₯Ό νκΈ° μν΄μ λΉλκΈ° μμμ΄ λλλ μκ°κΉμ§ `sleep` μ νκ³ , μ΄νμ κ²°κ³Ό κ°μ λΉκ΅νλ λ°©λ²μΌλ‘ μ§ννμμ΅λλ€. νμ§λ§, ν΄λΉ λ°©λ²μ μνν΄λ `totalCustomerCount` λ 0μΌλ‘ λ³νμ§ μλ λ¬Έμ κ° λ°μνμμ΅λλ€.

```swift
func test_κ³ κ°4λͺ_μνμλ¬΄_μ²λ¦¬ν_totalCustomerλΉκ΅() {
	bank.open()
  OperationQueue().addOperation {
    sleep(3)
    XCTAssertEqual(self.bankManager.showTotalCompletedCustomer(), 4)
  }
}
```

μ΄ν, λ¦¬λ·°μ΄μκ² `expectation(description:)`, `fulfill()`, `waitForExpectations(timeout:)` ν€μλλ₯Ό μΆμ²λ°μ, [Raywenderlich tutorial](https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial#toc-anchor-009) λ₯Ό μ°Έκ³ νμ¬ νμ€νΈλ₯Ό μννμ΅λλ€

`Operation`μ κ°μ²΄ν μμΌ `handler` λ₯Ό μ§μ  μμ±νκΈ°λ νμμΌλ©°, νΉμ μ΄λ―Έ κ°μ§κ³  μλ μΈμ€ν΄μ€ νλ‘νΌν° `completionBlock` μ νμ©ν΄μ `expectation.fulfill()` μ μ€νμμΌ°μ΅λλ€

```swift
///μκΈμμμ 0.7μ΄ μμ
///- timeout: 0.7μ΄μ testFailλ°μ
func test_DepositλΉλκΈ°_μκ°κ²½κ³Ό_νμ€νΈ() {
  //given
  let expectation = XCTestExpectation(description: "μκΈ μλ£")
  //when
  bankDepositTask.completionHandler = { _ in
                                       //then
                                       expectation.fulfill()
                                      }
  OperationQueue().addOperation(bankDepositTask)

  //μκΈμμ 0.7μ΄ μμ
  wait(for: [expectation], timeout: 0.71)
}
```

<br>

### Customerμ Priority μ§μ νλ λ°©λ² κ³ λ―Ό

μ΄κΈ° μ€κ³ν λͺ¨λΈμ κ²½μ° `Operation` κ°μ²΄νκ° μ΄λ€μ§μ§ μμ `queuePriority` μ€μ μ΄ λΆκ°λ₯ νλ€. κ·Έλμ `Customer` μ `grade` λ₯Ό ν΅ν΄ λΆλ₯νκ³ , μλ¬΄ μνμ ν  λλ§λ€ λμ μμμ μλ `grade` μ `Operation` μ΄ μλμ§ λμμμ΄ νμΈν΄μΌ νλ€. νμ§λ§, κ°μ²΄ν μ΄ν μ΄ λΆλΆμ `queuePriority` λ₯Ό ν΅ν΄ λ§€μ° κ°λ¨ν΄μ‘μΌλ©°, μ¬μ€μ μλ μ¬μ§μ κ°μ΄λ° λ `Operation Queue` κ° νμμμ΄μ§ κ²μ νμΈν  μ μλ€

**λ³κ²½ μ  Operation Queue Flow**

<img src="https://user-images.githubusercontent.com/64566207/117004470-1010e200-ad21-11eb-81f3-614cc903ded9.png" width="700">

**λ³κ²½ ν Operation Queue Flow**

<img src="https://user-images.githubusercontent.com/64566207/117004510-199a4a00-ad21-11eb-91ca-40ffbcd74368.png" width="700">

<br>

<br>

## νμ΅ ν€μλ

- Dispatch / DispatchQueue
- Operation / OperationQueue
- Semaphore κ³΅μ  μμ λ¬Έμ (κ²½μ μν©)
- κ΅μ°© μν (Dead Lock)
- λΉλκΈ° νλ‘κ·Έλλ° , λκΈ° νλ‘κ·Έλλ°
- λΉλκΈ° νλ‘κ·Έλλ° Unit Test, XCTestExpectation, fulfill() 

<br>

### λΈλ‘κ·Έ ν¬μ€ν - Kane

[GCD-Operation νμ΅](https://velog.io/@leeyoungwoozz/TIL-2021.04.30-Fri)

[GCD-Operation μ¬ν νμ΅](https://velog.io/@leeyoungwoozz/iOS-GCD-Operation)