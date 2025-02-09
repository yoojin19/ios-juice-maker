//
//  JuiceMakerTests.swift
//  JuiceMakerTests
//
//  Created by 박예빈 on 2022/02/16.
//

import XCTest
@testable import JuiceMaker

class JuiceMakerTests: XCTestCase {
    /// FruitStore의 Fruit 재고는 모두 10개로 초기화 되어 있다고 가졍한다.
    let fruitStore: FruitStore = FruitStore()
    
    func test_바나나가_1개가_추가되면_바나나가_11개가_된다() {
        let expectedNumber = 11
        fruitStore.addFruit(numberOf: 1, fruit: Fruit.banana)
        let result = fruitStore.getFruitCount(fruit: Fruit.banana)
        XCTAssertEqual(result, expectedNumber)
    }
    
    func test_딸기10개_바나나1개를_사용하면_딸기0개_바나나9개가_된다() {
        let juiceMaker = JuiceMaker()
        
        let strawberryExpectedNumber = 0
        let bananaExpectedNumber = 9
        do {
            let _ = try juiceMaker.makeJuice(juice: .strawberryBananaJuice)
            let strawberryResult: Bool = juiceMaker.getFruitCount(fruit: .strawberry) == strawberryExpectedNumber
            let bananaResult: Bool = juiceMaker.getFruitCount(fruit: .banana) == bananaExpectedNumber
            XCTAssertTrue(strawberryResult && bananaResult)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_딸기수량이_10인데_딸기_16개를_사용하려하면_주스를_만들지_않음() {
        let beforeOrderStrawberryCount = fruitStore.getFruitCount(fruit: .strawberry)
        
        do {
            try fruitStore.useFruit(fruits: [.strawberry: 16])
            XCTFail("딸기수량보다 많은데 사용하였습니다.")
        } catch JuiceMakerError.outOfStock {
            let AfterOrderStrawberryCount = fruitStore.getFruitCount(fruit: .strawberry)
            XCTAssertEqual(beforeOrderStrawberryCount, AfterOrderStrawberryCount)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
