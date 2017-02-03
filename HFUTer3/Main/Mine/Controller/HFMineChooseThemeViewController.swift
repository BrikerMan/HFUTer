//
//  HFMineChooseThemeViewController.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/2/3.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import UIKit
import SnapKit

class HFMineChooseThemeViewController: HFBaseViewController, XibBasedController {

    @IBOutlet weak var tableView: UITableView!
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return HFTheme.flatColors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as HFMineChooseColorCell
        if indexPath.section == 0 {
            cell.titleLabel.text           = "自定义"
            cell.colorView.backgroundColor = HFTheme.getColor(with: HFTheme.tintName)
        } else {
            cell.titleLabel.text           = HFTheme.flatColors[indexPath.row].name
            cell.colorView.backgroundColor = HFTheme.flatColors[indexPath.row].color
        }
        cell.accessoryType = HFTheme.tintName == HFTheme.flatColors[indexPath.row].name ? .checkmark : .none
        return cell
    }
}

extension HFMineChooseThemeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let color = HFTheme.flatColors[indexPath.row].color
            let hex = "\(color.redComponent)\(color.greenComponent)\(color.blueComponent)"
            HFTheme.saveTintColor(name: HFTheme.flatColors[indexPath.row].name, color: hex)
        } else {
            let custom = HFCustumRGBColorView()
            view.addSubview(custom)
            custom.snp.makeConstraints {
                $0.edges.equalTo(self.view)
            }
        }
    }
}
