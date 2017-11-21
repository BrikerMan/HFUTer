//
//  HFMineDonateVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import StoreKit
import AVOSCloud
import Crashlytics
import SwiftyStoreKit

enum RegisteredProducs : String {
    case Purchase1 = "biz.eliyar.level1"
    case Purchase2 = "biz.eliyar.level2"
    case Purchase3 = "biz.eliyar.level3"
    case Purchase4 = "biz.eliyar.level4"
    case Purchase5 = "biz.eliyar.level5"
    case Purchase6 = "biz.eliyar.level6"
}

class HFMineDonateVC: HFBaseViewController {
    
    var productes:[SKProduct] = []
    
    var models:[(id: String, title: String, description: String, price: Int)] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    var isLoadingAPI = false { didSet {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        } } }
    
    var thanksView = HFMineDonateSuccessView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "打赏作者"
        requestProductInfo()
        tableView.tableFooterView = UIView()
        
        
        view.addSubview(thanksView)
        thanksView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(NavbarHeight, 0, 0, 0))
        }
        thanksView.alpha = 0.0
        
        AnalyseManager.Donate.record()
    }
    
    
    fileprivate func buyProduct(_ product: SKProduct) {
        print("buy " + product.productIdentifier)
        hud.showLoading("正在购买")
        SwiftyStoreKit.purchaseProduct(product.productIdentifier, atomically: true) { result in
            switch result {
            case .success(let product):
                for model in self.models where model.id == product.productId {
                    var dic: HFRequestParam = [
                        "price":model.price as AnyObject,
                        "title":model.title as AnyObject
                    ]
                    dic["userID"]       = Int(DataEnv.user?.sid ?? "0") ?? 0
                    dic["username"]     = DataEnv.user?.name ?? "未登录"
                    dic["userIDString"] = DataEnv.user?.sid ?? ""
                    dic["userJson"] = DataEnv.user?.toDic()
                    let item = AVObject(className: "PurchaseList", dictionary: dic)
                    self.showThanksView(model.price)
                    
                    for item in self.productes where item.productIdentifier == product.productId {
                        Answers.logPurchase(withPrice: item.price,
                                            currency: "CNY",
                                            success: true,
                                            itemName: model.title,
                                            itemType: "打赏",
                                            itemId: model.id,
                                            customAttributes: [
                                                "userID"       : Int(DataEnv.user?.sid ?? "0") ?? 0,
                                                "username"     : DataEnv.user?.name ?? "未登录",
                                                "userIDString" :  DataEnv.user?.sid ?? ""
                            ])
                    }
                    item.save()
                }
                
                hud.dismiss()
            case .error(let error):
                hud.showError("购买失败")
                print("Purchase Failed: \(error)")
            }
        }
        hud.showLoading("正在购买")
    }
    
    
    
    fileprivate func showThanksView(_ cost:Int) {
        var name    = ""
        var avatar  = ""
        if let user = DataEnv.user {
            name    = user.name
            avatar  = user.image
        }
        thanksView.setup(name, avatar: avatar, cash: cost)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.thanksView.alpha = 1.0
        })
        
    }
    
    fileprivate func requestProductInfo() {
        isLoadingAPI = true
        if(SKPaymentQueue.canMakePayments()) {
            SwiftyStoreKit.retrieveProductsInfo([RegisteredProducs.Purchase2.rawValue,
                                                 RegisteredProducs.Purchase3.rawValue,
                                                 RegisteredProducs.Purchase4.rawValue,
                                                 RegisteredProducs.Purchase5.rawValue,
                                                 RegisteredProducs.Purchase6.rawValue,]) { result in
                                                    if result.retrievedProducts.isEmpty {
                                                        print("load failed")
                                                    } else {
                                                        print(result.retrievedProducts)
                                                        self.productes.removeAll()
                                                        for product in result.retrievedProducts {
                                                            self.productes.append(product)
                                                            self.models.append((product.productIdentifier, product.localizedTitle, product.localizedDescription, Int(product.price)))
                                                        }
                                                        self.isLoadingAPI = false
                                                        runOnMainThread {
                                                            self.tableView.reloadData()
                                                        }
                                                        
                                                    }
            }
        } else {
            print("please enable IAPS")
        }
    }
}

extension HFMineDonateVC: HFMineDonateCellDelegate {
    func onPressBuyButton(_ product: SKProduct) {
        self.buyProduct(product)
    }
}


extension HFMineDonateVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "donateInfoCell")
            return cell!
        } else if indexPath.section == 2 {
            if isLoadingAPI {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IPALoadingCell") as! HFDonateLoadingTableViewCell
                cell.activityIndector.startAnimating()
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "donateBuyCell") as! HFMineDonateCell
                cell.delegate = self
                cell.setup(productes[indexPath.row])
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dashangCell")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 , 1:
            return 1
        default:
            return isLoadingAPI ? 1 : productes.count
        }
    }
}

extension HFMineDonateVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 78
        } else if indexPath.section == 2 {
            if isLoadingAPI {
                return 40
            }
            return 60
        } else {
            if DataEnv.allowDashang {
                return ScreenWidth + 25
            } else {
                return 0
            }
        }
    }
}
