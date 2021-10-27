//
//  JuiceMaker - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

class JuiceMakerViewController: UIViewController {
    
    @IBOutlet var currentStrawberryStockLabel: UILabel!
    @IBOutlet var currentBanannaStockLabel: UILabel!
    @IBOutlet var currentPineappleStockLabel: UILabel!
    @IBOutlet var currentKiwiStockLabel: UILabel!
    @IBOutlet var currentMangoStockLabel: UILabel!
    
    var juiceMaker: JuiceMaker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        
        let fruitStore = FruitStore(fruitList: Fruit.allCases, amount: 10)
        juiceMaker = JuiceMaker(fruitStore: fruitStore)
        // Do any additional setup after loading the view.
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeStock),
                                               name: Notification.Name.stockChanged,
                                               object: nil)
    }
    
    func order(juice: JuiceMenu) {
        var orderedJuice: JuiceMenu?
        do {
            orderedJuice = try juiceMaker?.make(juice)
        } catch FruitStoreError.deficientStock {
            let failAlert = UIAlertController(title: "재료가 모자라요", message: "재고를 수정할까요?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler:  { _ in
                self.navigateToStockModificationVC(nil)
            })
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            failAlert.addAction(ok)
            failAlert.addAction(cancel)
            failAlert.preferredAction = ok
            self.present(failAlert, animated: true, completion: nil)
        } catch {
            return
        }
        guard let orderedJuice = orderedJuice else {
            return
        }
        let successAlert = UIAlertController(title: "\(orderedJuice) 나왔습니다!", message: "맛있게 드세요!", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "잘 먹겠습니다🤤", style: .default, handler: nil))
        self.present(successAlert, animated: true, completion: nil)
    }
    
    @objc
    private func changeStock(notification: Notification) {
        guard let fruit = notification.userInfo?.keys.first as? Fruit else {
            return
        }
        
        if let changedAmount = notification.userInfo?[fruit] as? Int {
            switch fruit {
            case .strawberry:
                self.currentStrawberryStockLabel.text = "\(changedAmount)"
            case .bananna:
                self.currentBanannaStockLabel.text = "\(changedAmount)"
            case .pineapple:
                self.currentPineappleStockLabel.text = "\(changedAmount)"
            case .kiwi:
                self.currentKiwiStockLabel.text = "\(changedAmount)"
            case .mango:
                self.currentMangoStockLabel.text = "\(changedAmount)"
            }
        }
    }
    
    @IBAction func navigateToStockModificationVC(_ sender: Any?) {
        let stockManagerVC = storyboard?.instantiateViewController(withIdentifier: "StockManagerVC") as! StockManagerViewController
        let navigationController = UINavigationController(rootViewController: stockManagerVC)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func pressOrderButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            order(juice: .strawberryJuice)
        case 1:
            order(juice: .banannaJuice)
        case 2:
            order(juice: .kiwiJuice)
        case 3:
            order(juice: .pineappleJuice)
        case 4:
            order(juice: .strawberryBanannaJuice)
        case 5:
            order(juice: .mangoJuice)
        case 6:
            order(juice: .mangoKiwiJuice)
        default:
            return
        }
    }
}

extension Notification.Name {
    static let stockChanged = Notification.Name(rawValue: "stockChanged")
}
