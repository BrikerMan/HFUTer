//
//  HFInfoPlanListChooseVC.swift
//  HFUTer3
//
//  Created by Eliyar Eziz on 16/3/28.
//  Copyright © 2016年 Eliyar Eziz. All rights reserved.
//

import UIKit

class HFInfoListPickerVC: HFBaseViewController {
    
    fileprivate var selectedBlock:((_ index:Int) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var items: [String] = []

    fileprivate var selectedIndex = 0
    
    func setItems(_ items: [String], selectedIndex: Int, withCallBackBlock block:((_ index:Int) -> Void)?) {
        self.selectedBlock = block
        self.selectedIndex = selectedIndex
        self.items = items
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib(nibName: "HFChooseTableViewCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "HFChooseTableViewCell")
        tableView.dataSource = self
        
        let indexPath = IndexPath(row: selectedIndex, section: 0)
        tableView.scrollToRow(at: indexPath , at: UITableViewScrollPosition.middle, animated: false)
    }
}


extension HFInfoListPickerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HFChooseTableViewCell", for: indexPath) as! HFChooseTableViewCell
        let isLast = indexPath.row == items.count - 1
        cell.setupCell(withTitle: items[indexPath.row], isLast: isLast)
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        return cell
    }
}

extension HFInfoListPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        selectedIndex = indexPath.row
        selectedBlock?(selectedIndex)
        _ = navigationController?.popViewController(animated: true)
    }
}
