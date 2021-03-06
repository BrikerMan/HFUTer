//
//  HFMineChooseThemeViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/3.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit
import Crashlytics

class HFMineChooseThemeViewController: HFBaseViewController, XibBasedController {

    @IBOutlet weak var tableView: UITableView!
    
    var allowCustom = true
    
    var selectedColor = HFTheme.tintName
    
    var selectedBlock: ((_ color: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerReusableCell(HFMineChooseColorCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = HFTheme.BlackAreaColor
        navTitle = "主题颜色"
    }

}

extension HFMineChooseThemeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return allowCustom ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 && allowCustom {
            return 1
        } else {
            return HFTheme.flatColors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFMineChooseColorCell
        if indexPath.section == 0 && allowCustom {
            cell.titleLabel.text           = "自定义"
            cell.colorView.backgroundColor = HFTheme.getColor(with: HFTheme.tintName)
        } else {
            cell.titleLabel.text           = HFTheme.flatColors[indexPath.row].name
            cell.colorView.backgroundColor = HFTheme.flatColors[indexPath.row].color
        }
        cell.accessoryType = selectedColor == HFTheme.flatColors[indexPath.row].name ? .checkmark : .none
        return cell
    }
}

extension HFMineChooseThemeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 && allowCustom {
            let custom = HFCustumRGBColorView()
            view.addSubview(custom)
            custom.snp.makeConstraints {
                $0.edges.equalTo(self.view)
            }
        } else {
            if let block = selectedBlock {
                block(HFTheme.flatColors[indexPath.row].name)
                self.pop()
            } else {
                let color = HFTheme.flatColors[indexPath.row]
                HFTheme.saveTintColor(name: color.name, color: color.color.hex())
                Answers.logCustomEvent(withName: "主题颜色替换",
                                               customAttributes: [
                                                "颜色名称": color.name])
            }
        }
        
        tableView.reloadData()
    }
}
