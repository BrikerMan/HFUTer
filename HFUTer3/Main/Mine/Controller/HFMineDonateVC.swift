//
//  HFMineDonateVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/5.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import StoreKit
import Crashlytics

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
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(64, 0, 0, 0))
        }
        thanksView.alpha = 0.0
        
        AnalyseManager.Donate.record()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    fileprivate func buyProduct(_ product: SKProduct) {
        print("buy " + product.productIdentifier)
        let pay = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
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
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: RegisteredProducs.Purchase1.rawValue,
                                        RegisteredProducs.Purchase2.rawValue,
                                        RegisteredProducs.Purchase3.rawValue,
                                        RegisteredProducs.Purchase4.rawValue,
                                        RegisteredProducs.Purchase5.rawValue,
                                        RegisteredProducs.Purchase6.rawValue )
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
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

extension HFMineDonateVC: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProduct = response.products
        
        for product in myProduct {
            models.append((product.productIdentifier, product.localizedTitle, product.localizedDescription, Int(product.price)))
        }
        isLoadingAPI = false
        productes = response.products
        tableView.reloadData()
    }
}

extension HFMineDonateVC: SKPaymentTransactionObserver {
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            
            let prodID = t.payment.productIdentifier as String
            print("IAP not setup \(prodID)")
            
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .purchased:
                let prodID = trans.payment.productIdentifier as String
                
                for model in models where model.id == prodID {
                    
                    var dic: HFRequestParam = [
                        "price":model.price as AnyObject,
                        "title":model.title as AnyObject
                    ]
                    dic["userID"]       = Int(DataEnv.user?.sid ?? "0") as AnyObject?? ?? 0 as AnyObject?
                    dic["username"]     = DataEnv.user?.name as AnyObject?? ?? "未登录" as AnyObject?
                    dic["userIDString"] = DataEnv.user?.sid as AnyObject?? ?? "" as AnyObject?
                    dic["userJson"] = DataEnv.user?.toDic() as AnyObject?
                    let item = AVObject(className: "PurchaseList", dictionary: dic)
                    showThanksView(model.price)
                    
                    for item in productes where item.productIdentifier == prodID {
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
                    
                    
                    
                    item?.save()
                }
                
                queue.finishTransaction(trans)
                hud.dismiss()
                
            case .failed:
                hud.showError("购买失败")
                queue.finishTransaction(trans)
                
            default:
                print("default")
                
                
            }
        }
    }
    
    func finishTransaction(_ trans:SKPaymentTransaction)
    {
        print("finish trans")
        SKPaymentQueue.default().finishTransaction(trans)
    }
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
    {
        print("remove trans");
    }
}

extension HFMineDonateVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if DataEnv.allowDashang {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "donateInfoCell")
            return cell!
        } else if indexPath.section == 1 {
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
        case 0 , 2:
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
        } else if indexPath.section == 1 {
            if isLoadingAPI {
                return 40
            }
            return 60
        } else {
            return ScreenWidth + 25
        }
    }
}
