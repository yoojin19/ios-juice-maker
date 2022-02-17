//
//  JuiceKioskViewController.swift
//  JuiceMaker
//
//  Created by Yoojin Park on 2022/02/16.
//

import UIKit

final class JuiceKioskViewController: UIViewController {
    // MARK: - Property
    private let juiceMaker = JuiceMaker()
    private var fruitsLabels: [Fruit: UILabel] = [:]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setFruitLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        patchData()
    }
    
    // MARK: - func
    private func setFruitLabels() {
        fruitsLabels = [.strawberry: strawberryCountLabel,
                        .banana: bananaCountLabel,
                        .pineapple: pineappleCountLabel,
                        .kiwi: kiwiCountLabel,
                        .mango: mangoCountLabel]
    }
    
    private func patchData() {
        for fruitLabel in fruitsLabels {
            guard let fruitCount = juiceMaker.fruitStore.stocks[fruitLabel.key] else {
                return
            }
            fruitLabel.value.text = "\(fruitCount)"
        }
    }
    
    private func orderJuice(of juice: Juice) {
        do {
            let answer = try juiceMaker.makeJuice(juice: juice)
            self.makeAlert(title: answer,
                           completion:  {
                self.patchData()
            })
        }
        catch {
            self.makeRequestAlert(title: error.localizedDescription,
                                  okAction: {_ in
                self.gotoModifyViewContoller()
            })
        }
    }
    
   private func gotoModifyViewContoller() {
        let vc = ModifyStocksViewController.instantiate(with: "Main")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Action
    @IBAction private func modifyButtonTap(_ sender: Any) {
        gotoModifyViewContoller()
    }
    
    @IBAction private func orderStrawBananaberryJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .strawberryBananaJuice)
    }
    @IBAction private func orderMangoKiwiJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .mangoKiwiJuice)
    }
    @IBAction private func orderStrawberryJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .strawberryJuice)
    }
    @IBAction private func orderBananaJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .bananaJuice)
    }
    @IBAction private func orderPineappleJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .pineappleJuice)
    }
    @IBAction private func orderKiwiJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .kiwiJuice)
    }
    @IBAction private func orderMangoJuiceButtonTap(_ sender: UIButton) {
        orderJuice(of: .mangoJuice)
    }
    
    // MARK: - Outlet Property
    @IBOutlet weak var strawberryCountLabel: UILabel!
    @IBOutlet weak var bananaCountLabel: UILabel!
    @IBOutlet weak var pineappleCountLabel: UILabel!
    @IBOutlet weak var kiwiCountLabel: UILabel!
    @IBOutlet weak var mangoCountLabel: UILabel!
}