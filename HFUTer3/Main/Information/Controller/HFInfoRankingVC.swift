//
//  HFInfoRankingVC.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/8/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFRankingModel: HFBaseModel {
    var term    = ""
    var index   = 0
    var average     : Double = 0.0
    var averageGPA  : Double = 0.0
}

class HFInfoRankingVC: HFBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var models: [HFRankingModel] = []
    var attempedNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataRequet()
        navTitle = "排名查询"
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDataRequet() {
        hud.showLoading("正在加载")
        HFBaseRequest.fire("/api/score/ranking", succesBlock: { (request, resultDic) in
            var models:[HFRankingModel] = []
            if let data = resultDic["data"] as? HFRequestParam,
                let list = data["list"] as? NSArray,
                let num = data["num"] as? Int {
                for item in list {
                    let model = HFRankingModel.yy_model(withJSON: item)
                    models.append(model!)
                }
                self.attempedNumber = num
            }
            self.models = models
            hud.dismiss()
            self.tableView.reloadData()
            
        }) { (request, error) in
            hud.showError(error)
        }
    }
    
    
}

extension HFInfoRankingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return models.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoRankingHeaderCell") as! HFInfoRankingHeaderCell
            cell.setup(attempedNumber)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HFInfoRankingDetailCell") as! HFInfoRankingDetailCell
            cell.setup(models[indexPath.row])
            return cell
        }
    }
}

extension HFInfoRankingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.fd_heightForCell(withIdentifier: "HFInfoRankingHeaderCell", cacheBy: indexPath, configuration: { (cell) in
                let cell = cell as? HFInfoRankingHeaderCell
                cell?.setup(self.attempedNumber)
            })
        } else {
            return 94
        }
    }
}
