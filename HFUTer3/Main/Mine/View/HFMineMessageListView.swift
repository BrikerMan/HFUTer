//
//  HFMineMessageListView.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/6/4.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit
import UITableView_FDTemplateLayoutCell_Bell

class HFMineMessageListView: HFXibView {
    
    @IBOutlet weak var tableView: HFPullTableView!
    
    var messageList: [HFMineMessageModel] = []
    var notifList: [HFMineNotifModel] = []
    
    var isNotif = false
    
    override func initFromXib() {
        super.initFromXib()
        tableView.registerReusableCell(HFMineMessageTableViewCell.self)
        tableView.registerReusableCell(HFMineNotifTableViewCell.self)
    }
    
    
    func setupWithMessage(_ messageList:[HFMineMessageModel]) {
        self.messageList = messageList
        self.tableView.reloadData()
    }
    
    func setupWithNotif(_ notifList:[HFMineNotifModel]) {
        self.notifList = notifList
        self.tableView.reloadData()
    }
    
}



extension HFMineMessageListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNotif {
            return notifList.count
        } else {
            return messageList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNotif {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFMineNotifTableViewCell
            cell.setup(notifList[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFMineMessageTableViewCell
            cell.setup(messageList[indexPath.row])
            return cell
        }
    }
}

extension HFMineMessageListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isNotif {
            let model = messageList[indexPath.row]
            if model.type == 100 {
                let confess = HFComLoveWallListModel()
                confess.id = model.type_id
                
                let vc = HFCommunityLoveWallDetailVC.instantiate()
                vc.mainModel = confess
                findViewController()!.pushVC(vc)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !self.isNotif {
            return tableView.fd_heightForCell(withIdentifier: "HFMineMessageTableViewCell", cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? HFMineMessageTableViewCell {
                    cell.setup(self.messageList[indexPath.row])
                }
            })
        } else {
            return tableView.fd_heightForCell(withIdentifier: "HFMineNotifTableViewCell", cacheBy: indexPath, configuration: { (cell) in
                if let cell = cell as? HFMineNotifTableViewCell {
                    cell.setup(self.notifList[indexPath.row])
                }
                
            })
        }
    }
}
