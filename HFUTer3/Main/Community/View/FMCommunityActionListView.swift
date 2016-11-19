//
//  FMCommunityActionListView.swift
//  HFUTer3
//
//  Created by BrikerMan on 16/5/23.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import Foundation


enum FMCommunityActionListButton {
    case postLostFind
    case contactLoster
    case mineLostFound
    
    case postLoveWall
}

protocol  FMCommunityActionListViewDelegate: class {
    func actionListView(_ listView: FMCommunityActionListView, didSelectedButton button:FMCommunityActionListButton)
}

class FMCommunityActionListView: HFXibView {
    
    weak var delegate: FMCommunityActionListViewDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var data:[(title:String, image:String, button:FMCommunityActionListButton)] = []
    
    func prepare(_ isLostFound: Bool) {
        if isLostFound {
            data = [
                ("发布失物招领","",FMCommunityActionListButton.postLostFind),
//                ("联系失主","",FMCommunityActionListButton.ContactLoster),
//                ("我的发布","",FMCommunityActionListButton.MineLostFound)
            ]
        } else {
            data = [
                ("发布表白","",FMCommunityActionListButton.postLoveWall)
            ]
        }
        tableViewHeight.constant = 60 * CGFloat(data.count)
        tableView.reloadData()
    }
    
    override func initFromXib() {
        super.initFromXib()
        view?.backgroundColor = UIColor.clear
        tableView.rowHeight = 60
        tableView.registerReusableCell(FMCommunityActionListViewCell.self)
    }
}

extension FMCommunityActionListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as FMCommunityActionListViewCell
        cell.titleLabel.text = data[indexPath.row].0
        return cell
    }
}

extension FMCommunityActionListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.actionListView(self, didSelectedButton: data[indexPath.row].2)
    }
}
